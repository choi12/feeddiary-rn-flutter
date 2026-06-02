// date_format — isSameDay·formatRelativeDate(오늘/올해/타해) (unit test, now 주입 결정적).
import 'package:feeddiary/utils/date_format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('isSameDay 는 연·월·일이 같으면 true', () {
    expect(isSameDay(DateTime(2026, 6, 1, 9), DateTime(2026, 6, 1, 23)), true);
    expect(isSameDay(DateTime(2026, 6, 1), DateTime(2026, 6, 2)), false);
    expect(isSameDay(DateTime(2025, 6, 1), DateTime(2026, 6, 1)), false);
  });

  group('formatRelativeDate', () {
    final now = DateTime(2026, 6, 2, 10);

    test('오늘이면 "오늘"', () {
      expect(formatRelativeDate(DateTime(2026, 6, 2, 8), now: now), '오늘');
    });

    test('올해 다른 날이면 "M월 D일"', () {
      expect(formatRelativeDate(DateTime(2026, 3, 4), now: now), '3월 4일');
    });

    test('다른 해면 "YYYY년 M월 D일"', () {
      expect(formatRelativeDate(DateTime(2025, 3, 4), now: now), '2025년 3월 4일');
    });
  });
}
