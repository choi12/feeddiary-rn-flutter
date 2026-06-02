// 캘린더 격자 유틸 — 6주x7일 격자·null 패딩·동일일자 필터·마킹 (unit, Tier A).
import 'package:feeddiary/data/models/diary.dart';
import 'package:feeddiary/ui/features/diary/calendar_grid.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('buildCalendarGrid 는 6주 x 7일 격자를 만든다', () {
    final grid = buildCalendarGrid(DateTime(2026, 6));
    expect(grid.length, 6);
    expect(grid.every((week) => week.length == 7), true);
  });

  test('첫 날이 올바른 요일 칸에 위치하고 그 앞은 null 이다', () {
    final month = DateTime(2026, 6);
    final grid = buildCalendarGrid(month);
    final leading = month.weekday % 7; // 일=0 기준
    expect(grid[0][leading], DateTime(2026, 6, 1));
    if (leading > 0) {
      expect(grid[0][leading - 1], isNull);
    }
  });

  test('이번 달의 모든 날짜가 빠짐없이 포함된다', () {
    final grid = buildCalendarGrid(DateTime(2026, 6));
    final days = grid
        .expand((week) => week)
        .whereType<DateTime>()
        .where((d) => d.month == 6)
        .map((d) => d.day)
        .toList();
    expect(days, List.generate(30, (i) => i + 1));
  });

  test('isSameDay / diariesOn / markedDays', () {
    final diaries = [
      DailyDiary(idx: 1, sticker: 'a', text: 't', createdAt: DateTime(2026, 6, 1, 10), isVisible: true),
      DailyDiary(idx: 2, sticker: 'b', text: 't', createdAt: DateTime(2026, 6, 1, 22), isVisible: false),
      DailyDiary(idx: 3, sticker: 'c', text: 't', createdAt: DateTime(2026, 6, 2), isVisible: true),
    ];
    expect(isSameDay(DateTime(2026, 6, 1, 10), DateTime(2026, 6, 1, 22)), true);
    expect(diariesOn(diaries, DateTime(2026, 6, 1)).length, 2);
    expect(markedDays(diaries).length, 2);
  });
}
