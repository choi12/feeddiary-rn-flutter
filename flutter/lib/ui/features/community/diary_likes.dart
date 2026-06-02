// 좋아요 글로벌 동기화 — idx별 좋아요 override 를 한곳에 모아 목록↔상세를 단일 소스로 묶는다. RN useLikeDiary+invalidateQueries.likeDiary 의 글로벌 Provider 승격.
import 'package:feeddiary/data/repositories/diary_repository.dart';
import 'package:feeddiary/ui/features/flowerpot/flowerpot_controller.dart';
import 'package:feeddiary/ui/features/flowerpot/mission_controller.dart';
import 'package:feeddiary/utils/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'diary_likes.g.dart';

/// 좋아요 상태(좋아요 여부 + 수). record 라 구조적 동등성을 가져 `select` 가 해당 idx 항목만 정확히 리빌드한다.
typedef LikeState = ({bool isLike, int likeCount});

/// 좋아요 글로벌 override 저장소. 같은 일기가 community 목록 카드와 상세에 동시 등장하므로,
/// 좋아요를 화면 로컬이 아닌 이 keepAlive provider 한 곳에 모아 양쪽이 같은 소스를 구독한다
/// (flutter/CLAUDE.md "유저 관계 상태=글로벌 Provider"). override 가 없으면 위젯은 서버값(base)을 그대로 쓴다.
///
/// RN 은 좋아요 후 DIARY·COMMUNITY 쿼리를 invalidate 해 동기화하지만, 우리 무한리스트(OffsetPagination)는
/// 부분 재조회가 불가해 invalidate 시 1페이지로 리셋된다. override 방식이 리스트 누적·스크롤을 보존한다.
@Riverpod(keepAlive: true)
class DiaryLikes extends _$DiaryLikes {
  @override
  Map<int, LikeState> build() => {};

  /// 좋아요 토글(낙관). 현재값은 override 또는 위젯이 넘긴 서버 base 다. 낙관 flip 후 서버 결과로 보정하고,
  /// 실패 시 base 로 revert 한 뒤 rethrow 한다. RN useLikeDiary(useOptimistic + likeDiary).
  Future<void> toggle({required int idx, required bool baseIsLike, required int baseLikeCount}) async {
    final current = state[idx] ?? (isLike: baseIsLike, likeCount: baseLikeCount);
    final optimistic = (
      isLike: !current.isLike,
      likeCount: current.isLike ? current.likeCount - 1 : current.likeCount + 1,
    );
    state = {...state, idx: optimistic};
    try {
      final result = await ref.read(diaryRepositoryProvider).likeDiary(diaryIdx: idx);
      state = {...state, idx: (isLike: result.isLike, likeCount: result.likeCount)};
      // 좋아요는 미션 진행(좋아요 미션)·화분을 교차 무효화한다(RN likeDiary → MISSION_GROUP).
      ref.invalidate(missionsControllerProvider);
      ref.invalidate(flowerpotControllerProvider);
    } catch (error, stackTrace) {
      AppLogger.error('좋아요 실패', error: error, stackTrace: stackTrace);
      state = {...state, idx: current};
      rethrow;
    }
  }
}
