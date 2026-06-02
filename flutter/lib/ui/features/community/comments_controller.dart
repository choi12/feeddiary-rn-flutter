// 댓글 컨트롤러 — 목록 조회 + 작성(재조회)·삭제(낙관). RN Comments/useCommentsQuery+useCreateComment+useDeleteComment 대응.
import 'package:feeddiary/data/models/comment.dart';
import 'package:feeddiary/data/repositories/community_repository.dart';
import 'package:feeddiary/ui/features/diary/diary_detail_controller.dart';
import 'package:feeddiary/utils/cache_policy.dart';
import 'package:feeddiary/utils/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comments_controller.g.dart';

/// 특정 일기의 댓글 목록 + 작성/삭제. 타인 액션 반영 가능성으로 realtime 캐시한다.
/// 작성은 비낙관(성공 후 재조회 — 서버 idx/시각 확정), 삭제는 낙관 제거 후 실패 시 롤백한다(RN 거동).
@riverpod
class CommentsController extends _$CommentsController {
  @override
  Future<List<Comment>> build(int diaryIdx) {
    ref.cacheFor(CachePolicy.realtimeGcTime);
    return ref.watch(communityRepositoryProvider).getComments(diaryIdx: diaryIdx);
  }

  /// 댓글 작성. 성공 후 목록을 재조회하고(서버 idx/시각 확정) 상세의 댓글 수를 무효화한다(RN createComment → invalidate DIARY).
  /// 빈 입력은 무시한다. 중복 전송 방지는 호출부(전송 버튼 비활성)에서 처리한다.
  Future<void> create(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return;
    }
    final repository = ref.read(communityRepositoryProvider);
    await repository.createComment(diaryIdx: diaryIdx, text: trimmed);
    ref.invalidate(diaryDetailControllerProvider(diaryIdx));
    state = await AsyncValue.guard(() => repository.getComments(diaryIdx: diaryIdx));
  }

  /// 댓글 삭제(낙관). 목록에서 즉시 제거 후, 실패 시 이전 목록으로 revert 하고 rethrow 한다. RN useDeleteComment.
  Future<void> delete(int commentIdx) async {
    final previous = state.value;
    if (previous == null) {
      return;
    }
    state = AsyncData(previous.where((comment) => comment.idx != commentIdx).toList());
    try {
      await ref.read(communityRepositoryProvider).deleteComment(commentIdx: commentIdx);
      ref.invalidate(diaryDetailControllerProvider(diaryIdx));
    } catch (error, stackTrace) {
      AppLogger.error('댓글 삭제 실패', error: error, stackTrace: stackTrace);
      state = AsyncData(previous);
      rethrow;
    }
  }
}
