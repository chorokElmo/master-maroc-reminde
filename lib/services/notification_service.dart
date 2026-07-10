import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../features/masters/domain/entities/master.dart';

/// Default reminder ladder applied automatically when a student saves a
/// Master: 30/15/7/3/1 days before the deadline, plus the deadline day
/// itself. Callers can pass a different set of day-offsets for custom
/// intervals.
const List<int> defaultReminderDaysBefore = [30, 15, 7, 3, 1, 0];

class NotificationService {
  static const String channelId = 'master_deadlines_channel';
  static const String channelName = 'Application Deadlines';
  static const String channelDescription =
      "Alerts you before a saved Master's application deadline";

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();
    try {
      final localTz = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(localTz));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
    );

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        channelId,
        channelName,
        description: channelDescription,
        importance: Importance.max,
      ),
    );

    _initialized = true;
  }

  Future<bool> requestPermissions() async {
    if (Platform.isIOS) {
      final granted = await _plugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return granted ?? false;
    }
    if (Platform.isAndroid) {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final notifGranted = await androidPlugin?.requestNotificationsPermission();
      await androidPlugin?.requestExactAlarmsPermission();
      return notifGranted ?? true;
    }
    return true;
  }

  NotificationDetails get _details => const NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: channelDescription,
          importance: Importance.max,
          priority: Priority.high,
          category: AndroidNotificationCategory.reminder,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

  Future<void> showImmediate({required int id, required String title, required String body}) {
    return _plugin.show(id, title, body, _details);
  }

  Future<void> cancel(int id) => _plugin.cancel(id);

  Future<void> cancelAll() => _plugin.cancelAll();

  Future<void> cancelMany(List<int> ids) async {
    for (final id in ids) {
      await _plugin.cancel(id);
    }
  }

  int _baseId(String masterId) => masterId.hashCode & 0x0FFFFFFF;

  /// Schedules the reminder ladder for [master]'s deadline. Any previously
  /// scheduled notifications for it (passed as [existingIds]) are cancelled
  /// first, so calling this again after editing intervals is always safe.
  /// Returns the new notification ids to persist against the favorite.
  Future<List<int>> scheduleForMaster(
    Master master, {
    List<int> existingIds = const [],
    List<int> daysBefore = defaultReminderDaysBefore,
  }) async {
    await cancelMany(existingIds);

    final deadline = master.applicationDeadline;
    if (deadline == null) return [];

    final base = _baseId(master.id);
    final newIds = <int>[];
    final now = DateTime.now();

    for (var i = 0; i < daysBefore.length; i++) {
      final triggerAt = DateTime(
        deadline.year,
        deadline.month,
        deadline.day,
        9,
      ).subtract(Duration(days: daysBefore[i]));

      if (!triggerAt.isAfter(now)) continue;

      final id = base + i;
      try {
        await _plugin.zonedSchedule(
          id,
          master.title,
          _bodyFor(master, daysBefore[i]),
          tz.TZDateTime.from(triggerAt, tz.local),
          _details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
        newIds.add(id);
      } catch (e) {
        if (kDebugMode) debugPrint('Failed to schedule Master reminder: $e');
      }
    }

    return newIds;
  }

  String _bodyFor(Master master, int daysBefore) {
    final place = master.university ?? master.faculty ?? master.city;
    final where = place != null ? ' at $place' : '';
    if (daysBefore == 0) return '"${master.title}"$where closes today.';
    if (daysBefore == 1) return '"${master.title}"$where closes tomorrow.';
    return '"${master.title}"$where closes in $daysBefore days.';
  }
}
