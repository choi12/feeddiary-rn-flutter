// 공유 일기 목록 컨트롤러 — 정렬별 오프셋 무한스크롤(OffsetPagination 재사용). RN useCommunityDiaries 대응.
import 'package:feeddiary/data/models/community_diary.dart';
import 'package:feeddiary/data/repositories/community_repository.dart';
import 'package:feeddiary/domain/models/community_sort.dart';
import 'package:feeddiary/ui/features/community/community_sort_provider.dart';
import 'package:feeddiary/utils/pagination.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 공유 일기 무한 목록. 정렬을 `communitySortControllerProvider` 로 watch 해, 정렬이 바뀌면 build 가 재실행되며
/// 1페이지부터 다시 로드한다(RN queryKey [COMMUNITY, sort] 대응). 페이지 누적·끝 감지는 OffsetPagination 믹스인.
class CommunityListNotifier extends AsyncNotifier<PagedState<CommunityDiary>> with OffsetPagination<CommunityDiary> {
  late CommunitySort _sort;

  @override
  Future<PagedState<CommunityDiary>> build() {
    _sort = ref.watch(communitySortControllerProvider);
    return loadFirst();
  }

  @override
  Future<List<CommunityDiary>> fetchPage(int skip) =>
      ref.read(communityRepositoryProvider).getCommunityDiaries(skip: skip, sort: _sort);
}

/// 믹스인을 public API 로 적용하려 수동 선언한다(PR④ `diaryListProvider` 와 동일 이유 — 코드젠 `$AsyncNotifier` 부적합).
/// family 대신 단일 notifier + 정렬 watch 로 둬 `FamilyAsyncNotifier` 와 믹스인 `on AsyncNotifier` 절의 호환 리스크를 피한다.
final communityListProvider = AsyncNotifierProvider<CommunityListNotifier, PagedState<CommunityDiary>>(
  CommunityListNotifier.new,
);
