// 월별 일기 provider — 캘린더용 특정 월 일기 목록(서버상태). RN useDiaryCalendarView 의 useQuery 대응.
import 'package:feeddiary/data/models/diary.dart';
import 'package:feeddiary/data/repositories/diary_repository.dart';
import 'package:feeddiary/utils/cache_policy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'monthly_diaries_provider.g.dart';

/// 특정 월(`YYYY-MM`)의 일기 목록. 본인 액션으로만 변경되므로 cacheFor(standard)로 캐시하고
/// 생성/수정/삭제 시 invalidate 한다. RN INDEPENDENT_QUERY_CONFIG.
@riverpod
Future<List<DailyDiary>> monthlyDiaries(Ref ref, String month) {
  ref.cacheFor(CachePolicy.standardGcTime);
  return ref.watch(diaryRepositoryProvider).getMonthlyDiaries(month: month);
}
