import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  static DateTime dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

  static int daysUntil(DateTime date) {
    final today = dateOnly(DateTime.now());
    final target = dateOnly(date);
    return target.difference(today).inDays;
  }

  static bool isToday(DateTime date) => daysUntil(date) == 0;

  static bool isTomorrow(DateTime date) => daysUntil(date) == 1;

  static bool isThisWeek(DateTime date) {
    final diff = daysUntil(date);
    return diff > 1 && diff <= 7;
  }

  static bool isThisMonth(DateTime date) {
    final diff = daysUntil(date);
    return diff > 7 && diff <= 30;
  }

  static bool isPast(DateTime date) => daysUntil(date) < 0;

  /// "Closes in 12 days" / "Closed 3 days ago" style copy for deadline
  /// badges and countdown widgets.
  static String remainingLabel(DateTime deadline) {
    final diff = daysUntil(deadline);
    if (diff == 0) return 'Closes today';
    if (diff == 1) return 'Closes tomorrow';
    if (diff == -1) return 'Closed yesterday';
    if (diff > 1) return 'Closes in $diff days';
    return 'Closed ${diff.abs()} days ago';
  }

  static String formatDate(DateTime date) => DateFormat.yMMMd().format(date);

  static String formatDateShort(DateTime date) => DateFormat('MMM d').format(date);

  static String formatTime(DateTime date) => DateFormat.jm().format(date);

  static String formatDateTime(DateTime date) => '${formatDate(date)} · ${formatTime(date)}';

  static String formatWeekday(DateTime date) => DateFormat.EEEE().format(date);
}
