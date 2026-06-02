// 공유 일기 정렬 상태 — SegmentedButton 선택을 목록 컨트롤러가 구독. RN useCommunitySort(useState) 대응.
import 'package:feeddiary/domain/models/community_sort.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'community_sort_provider.g.dart';

/// 현재 community 정렬 기준. 화면(SegmentedButton)과 목록 컨트롤러가 공유하는 작은 클라이언트 상태다.
@riverpod
class CommunitySortController extends _$CommunitySortController {
  @override
  CommunitySort build() => CommunitySort.latest;

  void set(CommunitySort sort) => state = sort;
}
