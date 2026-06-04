// 디자인 토큰 L1(원시) — RN constants/ui/font 매핑. 폰트 패밀리 이름 상수.

/// 폰트 패밀리 토큰. RN `FONTS` 대응. 실제 .ttf 에셋은 pubspec `fonts:` 블록에 번들된다(Dovemayo·Ownglyph + 아이콘 .ttf).
abstract final class FeedFonts {
  /// 본문·UI 기본 — 둥근 고딕.
  static const String dovemayo = 'Dovemayo_gothic';

  /// 손글씨 느낌 강조용.
  static const String ownglyph = 'Ownglyph_PDH-Rg';
}
