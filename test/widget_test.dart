import 'package:flutter_test/flutter_test.dart';
import 'package:master_maroc_reminder/core/utils/date_utils.dart';

void main() {
  group('AppDateUtils', () {
    test('remainingLabel describes a future deadline', () {
      final deadline = DateTime.now().add(const Duration(days: 5));
      expect(AppDateUtils.remainingLabel(deadline), contains('Closes in'));
    });

    test('remainingLabel flags today and tomorrow correctly', () {
      final today = DateTime.now();
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      expect(AppDateUtils.remainingLabel(today), 'Closes today');
      expect(AppDateUtils.remainingLabel(tomorrow), 'Closes tomorrow');
    });

    test('isPast is true for a date in the past', () {
      final past = DateTime.now().subtract(const Duration(days: 2));
      expect(AppDateUtils.isPast(past), isTrue);
    });
  });
}
