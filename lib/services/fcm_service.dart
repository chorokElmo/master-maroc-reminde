import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'notification_service.dart';

/// Thin wrapper around Firebase Cloud Messaging. Inert (every method is a
/// no-op) when Firebase hasn't been configured for this build — see
/// `firebase_options.dart` — so the rest of the app never has to branch on
/// whether push is available.
class FcmService {
  FcmService(this._notifications, {required bool isConfigured}) : _isConfigured = isConfigured;

  final NotificationService _notifications;
  final bool _isConfigured;

  String? _token;
  String? get token => _token;

  Future<void> init() async {
    if (!_isConfigured) return;

    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(alert: true, badge: true, sound: true);
    _token = await messaging.getToken();

    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      _notifications.showImmediate(
        id: message.hashCode & 0x0FFFFFFF,
        title: notification.title ?? 'Master Maroc Reminder',
        body: notification.body ?? '',
      );
    });

    messaging.onTokenRefresh.listen((newToken) {
      _token = newToken;
      if (kDebugMode) debugPrint('FCM token refreshed: $newToken');
    });
  }
}
