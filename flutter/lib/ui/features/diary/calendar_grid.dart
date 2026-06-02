// 캘린더 격자 유틸 — 기준 월을 6주 x 7일 2차원 배열로 변환(타 월 날짜는 null). RN hooks/features/calendar/useCalendar 1:1.
import 'package:feeddiary/data/models/diary.dart';

/// 기준 [month]를 받아 6주 x 7일 격자를 만든다. 이전/다음 달 칸은 null.
/// RN `useCalendar`: 시작 요일만큼 null + 이번 달 날짜 + 마지막 주 빈 칸 null → 6주로 분할(일요일 시작).
List<List<DateTime?>> buildCalendarGrid(DateTime month) {
  final firstOfMonth = DateTime(month.year, month.month);
  // Dart weekday 는 월=1 ~ 일=7. RN 은 일=0 기준이라 일요일 시작으로 맞춘다(일=0 ... 토=6).
  final leadingNulls = firstOfMonth.weekday % 7;
  final daysInMonth = DateTime(month.year, month.month + 1, 0).day;

  final cells = <DateTime?>[
    ...List<DateTime?>.filled(leadingNulls, null),
    for (var day = 1; day <= daysInMonth; day++) DateTime(month.year, month.month, day),
  ];
  // 6주(42칸)까지 뒤를 null 로 채운다.
  while (cells.length < 42) {
    cells.add(null);
  }
  return [for (var week = 0; week < 6; week++) cells.sublist(week * 7, week * 7 + 7)];
}

/// 같은 날짜(연·월·일)인지 비교. RN dayjs isSame(date, 'day').
bool isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

/// [diaries] 중 [day]에 작성된 항목만 필터링. RN useDiaryCalendarView 의 dailyDiaries.
List<DailyDiary> diariesOn(List<DailyDiary> diaries, DateTime day) =>
    diaries.where((d) => isSameDay(d.createdAt, day)).toList();

/// 일기가 있는 날짜 집합(격자 마킹용). 동일 날짜 키로 중복 제거.
Set<DateTime> markedDays(List<DailyDiary> diaries) => {
  for (final d in diaries) DateTime(d.createdAt.year, d.createdAt.month, d.createdAt.day),
};
