// 디자인 토큰 L1(원시) — 공통 그림자(elevation). RN constants/ui 의 boxShadow 문자열 매핑.
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:flutter/painting.dart';

/// 그림자 토큰. 테마와 무관한 불변값이라 정적 상수로 노출한다(`AppDimens` 패턴). RN `boxShadow` 대응.
abstract final class FeedShadows {
  /// 하단 탭바 그림자. RN `0px -2px 8px rgba(0,0,0,0.08)`.
  static const List<BoxShadow> tabBar = [
    BoxShadow(color: FeedPalette.shadowSoft, offset: Offset(0, -2), blurRadius: 8),
  ];
}
