// 공유 일기 정렬 기준 — 최신순/인기순. RN @/types/community CommunitySort 대응.

/// community 목록 정렬. 백엔드 `sort_type` 쿼리값이 enum 이름과 동일한 계약(latest/popular)이다.
enum CommunitySort {
  latest,
  popular;

  /// 백엔드 `sort_type` 쿼리 파라미터 값.
  String get queryValue => name;
}
