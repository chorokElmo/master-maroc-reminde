import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorite_entry.freezed.dart';
part 'favorite_entry.g.dart';

@freezed
class FavoriteEntry with _$FavoriteEntry {
  const factory FavoriteEntry({
    required String masterId,
    required DateTime addedAt,
    /// Ids of the currently scheduled local notifications for this
    /// Master's deadline, so they can be cancelled/rescheduled cleanly.
    @Default(<int>[]) List<int> notificationIds,
    /// Days-before-deadline ladder used to schedule reminders. Defaults to
    /// [defaultReminderDaysBefore] (30/15/7/3/1/0) when null — stored only
    /// when the user picks a custom interval.
    List<int>? customReminderDaysBefore,
  }) = _FavoriteEntry;

  factory FavoriteEntry.fromJson(Map<String, dynamic> json) =>
      _$FavoriteEntryFromJson(json);
}
