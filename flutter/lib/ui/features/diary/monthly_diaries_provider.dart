// 월별 일기 provider — 캘린더용 특정 월 일기 목록(서버상태). RN useDiaryCalendarView 의 useQuery 대응.
import 'package:feeddiary/data/models/diary.dart';
import 'package:feeddiary/data/repositories/diary_repository.dart';
import 'package:feeddiary/utils/cache_policy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'monthly_diaries_provider.g.dart';

/// 특정 월(`YYYY-MM`)의 일기 목록. 본인 액션으로만 변경되므로 cacheFor(standard)로 캐시하고
/// 생성/수정/삭제 시 invalidate 한다. RN INDEPENDENT_QUERY_CONFIG.
/// 삭제·공개 전환은 재조회 응답 전에 로드된 목록을 먼저 고친다(RN MONTHLY_DIARIES setQueryData).
@riverpod
class MonthlyDiaries extends _$MonthlyDiaries {
  @override
  Future<List<DailyDiary>> build(String month) {
    ref.cacheFor(CachePolicy.standardGcTime);
    return ref.watch(diaryRepositoryProvider).getMonthlyDiaries(month: month);
  }

  /// 로드된 목록에서 [diaryIdx] 일기를 즉시 뺀다. 미로드면 무시.
  void removeLocally(int diaryIdx) {
    final current = state.value;
    if (current == null) {
      return;
    }
    state = AsyncData(current.where((d) => d.idx != diaryIdx).toList());
  }

  /// 로드된 목록에서 [test]에 맞는 일기만 [transform] 으로 바꾼다. 미로드면 무시.
  void updateLocally(bool Function(DailyDiary diary) test, DailyDiary Function(DailyDiary diary) transform) {
    final current = state.value;
    if (current == null) {
      return;
    }
    state = AsyncData([for (final d in current) test(d) ? transform(d) : d]);
  }
}
