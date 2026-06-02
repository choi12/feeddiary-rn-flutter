// 디자인 토큰 L1(원시) — RN constants/ui/color 와 1:1 대응하는 순수 색상 팔레트.
import 'dart:ui' show Color;

/// 원시(primitive) 색상 토큰. 의미를 담지 않은 순수 팔레트이며, 시맨틱/컴포넌트
/// 토큰(AppColors)이 이 값을 참조한다. RN `COLORS` 상수와 1:1로 매핑된다.
abstract final class FeedPalette {
  // Core
  static const Color main = Color(0xFFB8D698);
  static const Color background = Color(0xFFF3F3F3);
  static const Color input = Color(0xFFDDDDDD);

  // Brand (green scale)
  static const Color lightGreen = Color(0xFFD4E5BB);
  static const Color green = Color(0xFFB8D698);
  static const Color darkGreen = Color(0xFF9AB77D);
  static const Color fieldGreen = Color(0xFFA8C209);

  // Grayscale
  static const Color white = Color(0xFFFFFFFF);
  static const Color whiteGray = Color(0xFFF3F3F3);
  static const Color lightGray = Color(0xFFD5D5D5);
  static const Color gray = Color(0xFFB5B5B5);
  static const Color darkGray = Color(0xFF858484);
  static const Color lightBlack = Color(0xFF6A6A6A);
  static const Color black = Color(0xFF4A4A4A);
  static const Color darkBlack = Color(0xFF333333);
  static const Color paleGray = Color(0xFFEFEFEF);
  static const Color silverGray = Color(0xFFE9E9E9);
  static const Color mediumGray = Color(0xFF8E8E8E);
  static const Color slateGray = Color(0xFF656D84);

  // Accent
  static const Color blue = Color(0xFF3E82F1);
  static const Color skyblue = Color(0xFF8CD5E1);
  static const Color red = Color(0xFFE74133);
  static const Color orange = Color(0xFFEB7F2E);
  static const Color yellow = Color(0xFFF9BB00);
  static const Color lime = Color(0xFFD1F005);
  static const Color olive = Color(0xFFB6CA4D);
  static const Color beige = Color(0xFFF0EDDF);
  static const Color lightBeige = Color(0xFFE7E2CC);

  // Overlay / elevation — RN `TRANSPARENT.BLACK_*` · boxShadow 의 반투명 검정.
  /// 모달 dim. RN `rgba(0,0,0,0.3)`.
  static const Color scrim = Color(0x4D000000);

  /// 이미지 모달 dim. RN `rgba(0,0,0,0.9)`.
  static const Color scrimHeavy = Color(0xE6000000);

  /// 탭바 등 옅은 그림자. RN `rgba(0,0,0,0.08)`.
  static const Color shadowSoft = Color(0x14000000);
}
