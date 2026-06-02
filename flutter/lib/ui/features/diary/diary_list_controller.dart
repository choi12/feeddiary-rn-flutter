// 내 일기 목록 컨트롤러 — 오프셋 무한스크롤(OffsetPagination 믹스인). RN useDiaryCardView(useInfiniteQuery) 대응.
import 'package:feeddiary/data/models/diary.dart';
import 'package:feeddiary/data/repositories/diary_repository.dart';
import 'package:feeddiary/utils/pagination.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 내 일기 무한 목록. `OffsetPagination` 믹스인이 페이지 누적·끝 감지를 처리하고, 여기서는 페이지 fetch 만
/// repository 로 위임한다. keepAlive(본인 액션으로만 변경 — RN INDEPENDENT_QUERY_CONFIG).
class DiaryListNotifier extends AsyncNotifier<PagedState<MyDiary>> with OffsetPagination<MyDiary> {
  @override
  Future<PagedState<MyDiary>> build() => loadFirst();

  @override
  Future<List<MyDiary>> fetchPage(int skip) => ref.read(diaryRepositoryProvider).getDiaries(skip: skip);
}

/// 코드젠 `$AsyncNotifier`(`@publicInCodegen`) 대신 공용 `AsyncNotifier`를 베이스로 둬야 `OffsetPagination`
/// 믹스인을 public API 로 적용할 수 있어, 이 provider 만 수동 선언한다(나머지는 `@riverpod` 코드젠).
final diaryListProvider = AsyncNotifierProvider<DiaryListNotifier, PagedState<MyDiary>>(DiaryListNotifier.new);
