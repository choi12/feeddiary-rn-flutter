// 날짜 포맷 유틸 — 일기 표시·월별 키용 문자열. RN utils/common/formatDate + dayjs.format 대응.

/// 2자리 0 패딩.
String pad2(int value) => value.toString().padLeft(2, '0');

/// 월별 조회 키 `YYYY-MM`. RN dayjs.format('YYYY-MM').
String monthKey(DateTime date) => '${date.year}-${pad2(date.month)}';

/// 표시용 `YYYY.MM.DD`.
String formatYmd(DateTime date) => '${date.year}.${pad2(date.month)}.${pad2(date.day)}';

/// 일기 상세 헤더용 `YYYY년 M월 D일`.
String formatDiaryDate(DateTime date) => '${date.year}년 ${date.month}월 ${date.day}일';

/// 두 날짜가 같은 날(연·월·일)인가. RN dayjs.isSame(_, 'day').
bool isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

/// 카드/목록용 상대 표기. 오늘이면 `오늘`, 같은 해면 `M월 D일`, 다른 해면 `YYYY년 M월 D일`.
/// RN formatDate(_, 'diary') 대응. [now]를 주입하면 결정적(테스트용).
String formatRelativeDate(DateTime date, {DateTime? now}) {
  final base = now ?? DateTime.now();
  if (isSameDay(date, base)) {
    return '오늘';
  }
  if (date.year == base.year) {
    return '${date.month}월 ${date.day}일';
  }
  return formatDiaryDate(date);
}

/// 댓글용 상대 날짜 + 시각. 예 `오늘, 오후 2:10` · `3월 4일, 오전 9:30`.
/// RN formatDate(_) 기본 포맷(상대 날짜 뒤 오전/오후 h:mm) 대응. [now]를 주입하면 결정적(테스트용).
String formatDateTime(DateTime date, {DateTime? now}) {
  final isPm = date.hour >= 12;
  final hour12 = date.hour % 12 == 0 ? 12 : date.hour % 12;
  final time = '${isPm ? '오후' : '오전'} $hour12:${pad2(date.minute)}';
  return '${formatRelativeDate(date, now: now)}, $time';
}
