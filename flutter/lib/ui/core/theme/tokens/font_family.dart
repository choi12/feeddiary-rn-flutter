// 디자인 토큰 L1(원시) — RN constants/ui/font 매핑. 폰트 패밀리 이름 상수.

/// 폰트 패밀리 토큰. RN `FONTS` 대응. 실제 .ttf 에셋 번들(pubspec `fonts:`)은 후속 PR에서
/// 추가하며, 그 전까지 Flutter는 시스템 폰트로 자동 폴백한다(런타임 에러 없음).
abstract final class FeedFonts {
  /// 본문·UI 기본 — 둥근 고딕.
  static const String dovemayo = 'Dovemayo_gothic';

  /// 손글씨 느낌 강조용.
  static const String ownglyph = 'Ownglyph_PDH-Rg';
}
