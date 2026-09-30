// 일기 상세 컨트롤러 — 상세 조회 + 공개여부 낙관적 토글 + 삭제. RN useDiaryDetails 대응(좋아요는 DiaryLikes 글로벌 provider).
import 'package:feeddiary/data/models/community_diary.dart';
import 'package:feeddiary/data/repositories/diary_repository.dart';
import 'package:feeddiary/ui/features/community/community_list_controller.dart';
import 'package:feeddiary/ui/features/diary/diary_list_controller.dart';
import 'package:feeddiary/ui/features/diary/monthly_diaries_provider.dart';
import 'package:feeddiary/ui/features/flowerpot/flowerpot_controller.dart';
import 'package:feeddiary/ui/features/flowerpot/mission_controller.dart';
import 'package:feeddiary/utils/cache_policy.dart';
import 'package:feeddiary/utils/date_format.dart';
import 'package:feeddiary/utils/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'diary_detail_controller.g.dart';

/// 일기 상세 상태. 공개여부는 낙관적으로 즉시 반영하고 실패 시 이전 상태로 되돌린다
/// (RN useOptimistic). 좋아요는 목록↔상세 동기화를 위해 `DiaryLikes` 글로벌 provider 가 담당한다.
/// 타인 액션 반영 가능성으로 realtime 캐시.
@riverpod
class DiaryDetailController extends _$DiaryDetailController {
  @override
  Future<CommunityDiary> build(int diaryIdx) {
    ref.cacheFor(CachePolicy.realtimeGcTime);
    return ref.watch(diaryRepositoryProvider).getDiary(diaryIdx: diaryIdx);
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
      // 내 일기 목록·월별은 그 항목의 공개 배지만 바꾼다 — 무효화하면 목록이 첫 페이지로 돌아가 더 불러온 페이지와
      // 스크롤을 잃는다. 공유 목록은 비공개 전환이면 그 일기만 빼고(피드에서 열었을 때 페이지 유지), 공개 전환이면
      // 새로 나타나야 하므로 무효화한다. 미션 진행(공개 미션)·화분은 교차 무효화한다
      // (RN setVisibility → DIARIES_GROUP·MISSION_GROUP).
      if (ref.exists(diaryListProvider)) {
        ref
            .read(diaryListProvider.notifier)
            .updateLocally((d) => d.idx == diaryIdx, (d) => d.copyWith(isVisible: visible));
      }
      final month = monthlyDiariesProvider(monthKey(current.createdAt));
      if (ref.exists(month)) {
        ref.read(month.notifier).updateLocally((d) => d.idx == diaryIdx, (d) => d.copyWith(isVisible: visible));
      }
      if (visible) {
        ref.invalidate(communityListProvider);
      } else if (ref.exists(communityListProvider)) {
        ref.read(communityListProvider.notifier).removeLocally((d) => d.idx == diaryIdx);
      }
      ref.invalidate(missionsControllerProvider);
      ref.invalidate(flowerpotControllerProvider);
    } catch (error, stackTrace) {
      AppLogger.error('공개 설정 실패', error: error, stackTrace: stackTrace);
      state = AsyncData(current);
      rethrow;
    }
  }

  /// 일기 삭제 후 목록/월별/공유 목록 캐시를 무효화한다. RN useDiaryActions.deleteDiary(DIARIES_GROUP).
  /// 무효화는 재조회 동안 이전 목록을 그대로 보여 주므로, 화면이 pop 되기 전에 로드된 세 목록(내 일기·그 달·공유)에서
  /// 먼저 빼 둔다(안 열어 본 목록은 `exists` 로 건너뛰어 읽기만으로 첫 로드를 일으키지 않는다).
  Future<void> delete() async {
    final createdAt = state.value?.createdAt;
    await ref.read(diaryRepositoryProvider).deleteDiary(diaryIdx: diaryIdx);
    if (createdAt != null && ref.exists(monthlyDiariesProvider(monthKey(createdAt)))) {
      ref.read(monthlyDiariesProvider(monthKey(createdAt)).notifier).removeLocally(diaryIdx);
    }
    if (ref.exists(diaryListProvider)) {
      ref.read(diaryListProvider.notifier).removeLocally((d) => d.idx == diaryIdx);
    }
    if (ref.exists(communityListProvider)) {
      ref.read(communityListProvider.notifier).removeLocally((d) => d.idx == diaryIdx);
    }
    ref.invalidate(diaryListProvider);
    ref.invalidate(monthlyDiariesProvider);
    ref.invalidate(communityListProvider);
  }
}
