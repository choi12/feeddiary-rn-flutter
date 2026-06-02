// 공유 일기 정렬 기준 — 최신순/인기순. RN @/types/community CommunitySort 대응.

/// community 목록 정렬. 백엔드 `sort_type` 쿼리값이 enum 이름과 동일한 계약(latest/popular)이다.
enum CommunitySort {
  latest,
  popular;

  /// 백엔드 `sort_type` 쿼리 파라미터 값.
  String get queryValue => name;

  /// 정렬 드롭다운 라벨. RN `MODAL_CONTENT.DIARY.SORT`(최신글/인기글).
  String get label => switch (this) {
    CommunitySort.latest => '최신글',
    CommunitySort.popular => '인기글',
  };
}
