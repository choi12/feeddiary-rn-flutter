export const LAYOUT = {
  HEADER_HEIGHT: 70,
  BOTTOM_TAB_HEIGHT: 75,

  INPUT_HEIGHT: 57,
  BUTTON_HEIGHT: 54,

  PADDING: 24,
  BORDER_RADIUS: 14,

  // 안드로이드 하단 여백 폴백값 — safe area inset 을 못 읽을 때만 사용
  BOTTOM_INSET_ANDROID: 20,

  STATUS_BAR_HEIGHT: 7, // iOS 상태 바 높이 보정값

  // 화면 중앙 정렬을 위한 기본 비율
  VERTICAL_POSITION_RATIO: 2.3,
  VERTICAL_OFFSET_MULTIPLIER: 1.3,
} as const;
