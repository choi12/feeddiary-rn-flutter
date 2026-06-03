// 화분 풀 캔버스 절대배치 기하 — verticalCenter 수식·식물/사이드패널/exp 오프셋. RN calculateVerticalCenter + LAYOUT/컴포넌트 상수 대응.

/// 화분 캔버스의 절대배치 좌표 상수와 verticalCenter 계산을 모은다. RN 은 기기 높이로부터
/// `((H − bottomInset − 7) / 2.3) * 1.3`(기하중앙 /2 이 아님)을 구해 식물·사이드패널을 배치하므로,
/// Align fraction 으로는 기기 길이차를 못 맞춘다 — 이 수식을 그대로 전사한다. RN `calculateVerticalCenter` + `LAYOUT`.
abstract final class FlowerpotLayout {
  /// 상단 상태바 보정. RN `LAYOUT.STATUS_BAR_HEIGHT`.
  static const double statusBarHeight = 7;

  /// verticalCenter 분모. RN `LAYOUT.VERTICAL_POSITION_RATIO`(/2 가 아닌 /2.3).
  static const double verticalPositionRatio = 2.3;

  /// verticalCenter 배수. RN `LAYOUT.VERTICAL_OFFSET_MULTIPLIER`.
  static const double verticalOffsetMultiplier = 1.3;

  /// 경험치 바 상단 오프셋(safe-area top 에 더한다). RN ExpBox `BASE_TOP_OFFSET`.
  static const double expTopOffset = 45;

  /// 사이드패널 top = verticalCenter − 이 값. RN SidePanel `VERTICAL_OFFSET`.
  static const double sidePanelOffset = 260;

  /// 식물 컨테이너(180×220) 좌상단 보정 translate. RN LemonyBox `transform translateX/Y`.
  /// 가로중앙 = W/2(−90+90), 세로중앙 = verticalCenter−70(−180+110).
  static const double plantTranslateX = -90;
  static const double plantTranslateY = -180;

  /// RN `calculateVerticalCenter(height, bottomInset)` = `((height − bottomInset − 7) / 2.3) * 1.3`.
  static double verticalCenter(double height, double bottomInset) {
    final adjustedHeight = height - bottomInset - statusBarHeight;
    return (adjustedHeight / verticalPositionRatio) * verticalOffsetMultiplier;
  }
}
