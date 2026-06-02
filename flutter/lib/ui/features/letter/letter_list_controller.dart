// 편지 목록 컨트롤러 — 오프셋 무한스크롤(OffsetPagination) + 작성(비낙관)·삭제(낙관). RN useLetters/useCreateLetter/useDeleteLetter 대응.
import 'package:feeddiary/data/models/letter.dart';
import 'package:feeddiary/data/repositories/letter_repository.dart';
import 'package:feeddiary/utils/date_format.dart';
import 'package:feeddiary/utils/logger.dart';
import 'package:feeddiary/utils/pagination.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 나의 편지 무한 목록. 페이지 누적·끝 감지는 OffsetPagination 믹스인이 처리하고, 여기서는 fetch·작성·삭제를 담당한다.
/// 수동 `AsyncNotifierProvider`는 autoDispose 되지 않아 keepAlive(=RN INDEPENDENT_QUERY_CONFIG, 본인 액션만 변경)로 동작한다.
/// 편지는 격리 도메인이라 작성/삭제는 LETTERS(이 provider)만 갱신한다 — 게임 루프(미션/화분)·좋아요와 무관하다.
class LetterListNotifier extends AsyncNotifier<PagedState<Letter>> with OffsetPagination<Letter> {
  @override
  Future<PagedState<Letter>> build() => loadFirst();

  @override
  Future<List<Letter>> fetchPage(int skip) => ref.read(letterRepositoryProvider).getLetters(skip: skip);

  /// 편지가 한 통이라도 있는가. RN useLetters.hasLetter.
  bool get hasLetter => state.value?.items.isNotEmpty ?? false;

  /// 오늘 이미 편지를 썼는가(최신 편지가 오늘). 작성 버튼 게이팅(하루 한 통)에 쓴다. RN useLetters.isTodayLetterWritten.
  bool get isTodayLetterWritten {
    final items = state.value?.items;
    if (items == null || items.isEmpty) {
      return false;
    }
    return isSameDay(items.first.createdAt, DateTime.now());
  }

  /// 편지 작성(비낙관). 빈 입력은 무시하고, 성공 후 1페이지부터 재조회한다(서버 idx/시각 확정). RN useCreateLetter.
  Future<void> create(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return;
    }
    await ref.read(letterRepositoryProvider).createLetter(text: trimmed);
    state = await AsyncValue.guard(loadFirst);
  }

  /// 편지 삭제(낙관). 목록에서 즉시 제거 후, 실패 시 이전 목록으로 revert 하고 rethrow 한다. RN useDeleteLetter.
  Future<void> delete(int letterIdx) async {
    final previous = state.value;
    if (previous == null) {
      return;
    }
    state = AsyncData(previous.copyWith(items: previous.items.where((letter) => letter.idx != letterIdx).toList()));
    try {
      await ref.read(letterRepositoryProvider).deleteLetter(letterIdx: letterIdx);
    } catch (error, stackTrace) {
      AppLogger.error('편지 삭제 실패', error: error, stackTrace: stackTrace);
      state = AsyncData(previous);
      rethrow;
    }
  }
}

/// 믹스인을 public API 로 적용하려 수동 선언한다(diary_list/community_list 와 동일 이유 — 코드젠 `$AsyncNotifier` 부적합).
final letterListProvider = AsyncNotifierProvider<LetterListNotifier, PagedState<Letter>>(LetterListNotifier.new);
