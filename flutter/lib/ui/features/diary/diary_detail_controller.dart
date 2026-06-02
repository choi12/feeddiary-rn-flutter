// 일기 상세 컨트롤러 — 상세 조회 + 좋아요/공개여부 낙관적 토글. RN useDiaryDetails + useLikeDiary 대응.
import 'package:feeddiary/data/models/community_diary.dart';
import 'package:feeddiary/data/repositories/diary_repository.dart';
import 'package:feeddiary/ui/features/diary/diary_list_controller.dart';
import 'package:feeddiary/ui/features/diary/monthly_diaries_provider.dart';
import 'package:feeddiary/utils/cache_policy.dart';
import 'package:feeddiary/utils/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'diary_detail_controller.g.dart';

/// 일기 상세 상태. 좋아요/공개여부는 낙관적으로 즉시 반영하고 실패 시 이전 상태로 되돌린다
/// (RN useOptimistic + useTransition). 타인 액션 반영 가능성으로 realtime 캐시.
@riverpod
class DiaryDetailController extends _$DiaryDetailController {
  @override
  Future<CommunityDiary> build(int diaryIdx) {
    ref.cacheFor(CachePolicy.realtimeGcTime);
    return ref.watch(diaryRepositoryProvider).getDiary(diaryIdx: diaryIdx);
  }

  /// 좋아요 토글(낙관). 성공 시 서버 값으로 보정, 실패 시 이전 상태로 revert 후 재throw. RN useLikeDiary.
  Future<void> toggleLike() async {
    final current = state.value;
    if (current == null) {
      return;
    }
    state = AsyncData(
      current.copyWith(
        isLike: !current.isLike,
        likeCount: current.isLike ? current.likeCount - 1 : current.likeCount + 1,
      ),
    );
    try {
      final result = await ref.read(diaryRepositoryProvider).likeDiary(diaryIdx: diaryIdx);
      state = AsyncData(current.copyWith(isLike: result.isLike, likeCount: result.likeCount));
    } catch (error, stackTrace) {
      AppLogger.error('좋아요 실패', error: error, stackTrace: stackTrace);
      state = AsyncData(current);
      rethrow;
    }
  }

  /// 공개 여부 토글(낙관). 실패 시 revert 후 재throw. RN useDiaryDetails.toggleVisibility.
  Future<void> toggleVisibility() async {
    final current = state.value;
    if (current == null) {
      return;
    }
    state = AsyncData(current.copyWith(isVisible: !current.isVisible));
    try {
      final visible = await ref.read(diaryRepositoryProvider).setVisibility(diaryIdx: diaryIdx);
      state = AsyncData(current.copyWith(isVisible: visible));
    } catch (error, stackTrace) {
      AppLogger.error('공개 설정 실패', error: error, stackTrace: stackTrace);
      state = AsyncData(current);
      rethrow;
    }
  }

  /// 일기 삭제 후 목록/월별 캐시를 무효화한다. RN useDiaryActions.deleteDiary.
  Future<void> delete() async {
    await ref.read(diaryRepositoryProvider).deleteDiary(diaryIdx: diaryIdx);
    ref.invalidate(diaryListProvider);
    ref.invalidate(monthlyDiariesProvider);
  }
}
