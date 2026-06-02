// 날짜 포맷 유틸 — 일기 표시·월별 키용 문자열. RN utils/common/formatDate + dayjs.format 대응.

/// 2자리 0 패딩.
String pad2(int value) => value.toString().padLeft(2, '0');

/// 월별 조회 키 `YYYY-MM`. RN dayjs.format('YYYY-MM').
String monthKey(DateTime date) => '${date.year}-${pad2(date.month)}';

/// 표시용 `YYYY.MM.DD`.
String formatYmd(DateTime date) => '${date.year}.${pad2(date.month)}.${pad2(date.day)}';

/// 일기 상세 헤더용 `YYYY년 M월 D일`.
String formatDiaryDate(DateTime date) => '${date.year}년 ${date.month}월 ${date.day}일';
