// 화분 파생 통계 — 화분 상태에서 레벨·경험치·물주기/사랑 가능 여부를 계산. RN useFlowerpotStats 대응.
import 'package:feeddiary/config/flowerpot_config.dart';
import 'package:feeddiary/data/models/flowerpot.dart';

/// 화분 상태로부터 화면이 쓰는 파생값을 계산한다. 서버상태가 아니라 순수 계산이라 provider 가 아닌
/// 값 클래스로 둔다(AsyncValue 래핑 없이 단위테스트 용이). RN `useFlowerpotStats`(useMemo).
class FlowerpotStats {
  const FlowerpotStats({
    required this.level,
    required this.exp,
    required this.maxExp,
    required this.wateringCount,
    required this.loveCount,
    required this.showBadge,
    required this.isMaxLevel,
    required this.canWater,
    required this.canLove,
  });

  /// [flowerpot]이 null 이면 [FlowerpotConfig] 기본값으로 채운다. RN useFlowerpotStats 의 `?? DEFAULT` 분기.
  factory FlowerpotStats.from(Flowerpot? flowerpot) {
    final level = flowerpot?.level ?? FlowerpotConfig.defaultLevel;
    final wateringCount = flowerpot?.wateringCount ?? 0;
    final loveCount = flowerpot?.loveCount ?? 0;
    // 최대 레벨 미만일 때만 물/사랑 가능(RN level <= 2, MAX_LEVEL 3).
    final belowMax = level < FlowerpotConfig.maxLevel;
    return FlowerpotStats(
      level: level,
      exp: flowerpot?.exp ?? FlowerpotConfig.defaultExp,
      maxExp: flowerpot?.maxExp ?? FlowerpotConfig.defaultMaxExp,
      wateringCount: wateringCount,
      loveCount: loveCount,
      showBadge: flowerpot?.showBadge ?? false,
      isMaxLevel: level >= FlowerpotConfig.maxLevel,
      canWater: flowerpot != null && belowMax && wateringCount >= 1,
      canLove: flowerpot != null && belowMax && loveCount >= 1,
    );
  }

  final int level;
  final int exp;
  final int maxExp;
  final int wateringCount;
  final int loveCount;
  final bool showBadge;
  final bool isMaxLevel;
  final bool canWater;
  final bool canLove;

  /// exp 진행률(0.0~1.0). 프로그레스 바 표시용.
  double get expProgress => maxExp <= 0 ? 0 : (exp / maxExp).clamp(0.0, 1.0);
}
