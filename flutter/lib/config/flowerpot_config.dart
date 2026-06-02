// 화분 게임 규칙 상수 — 최대 레벨·기본 경험치. RN constants/flowerpot/level(FLOWERPOT_CONFIG) 대응.

/// 화분 레벨/경험치 규칙. 실제 계산은 서버가 하지만, 클라 파생 stats(FlowerpotStats)와 데모 mock 의
/// 레벨업 상한에 이 상수를 쓴다(하드코딩 금지). RN `FLOWERPOT_CONFIG`.
abstract final class FlowerpotConfig {
  static const int maxLevel = 3;
  static const int defaultLevel = 1;
  static const int defaultExp = 0;
  static const int defaultMaxExp = 1000;
}
