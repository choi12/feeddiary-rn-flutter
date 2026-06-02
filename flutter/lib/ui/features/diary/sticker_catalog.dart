// 스티커 카탈로그 — 백엔드 스티커 name 을 번들 PNG 에셋 경로로 매핑. RN STICKER_ICONS 1:1, 저장값은 name 문자열 유지.
abstract final class StickerCatalog {
  static const String _base = 'assets/images/sticker';

  /// 선택 가능한 스티커 name 목록(작성 화면 그리드 순서). RN STICKER_ICONS 순서 1:1.
  /// 파일명은 `name.toLowerCase().png`(weather 9 + sticker 18).
  static const List<String> names = [
    'CloudSun',
    'Star',
    'Snow',
    'BlueMoon',
    'Rainbow',
    'Rain',
    'Thunder',
    'Moon',
    'Sunny',
    'Blanket',
    'Boxing',
    'Break',
    'Broken',
    'Coffee',
    'Flower',
    'Happiness',
    'Note',
    'Offer',
    'Restaurant',
    'Sleep',
    'Smile',
    'Sticker',
    'Sticker3',
    'Thinking',
    'Ticket',
    'Video',
    'Window',
  ];

  /// 작성 폼 기본 스티커. RN STICKER_ICONS[0].
  static const String defaultName = 'CloudSun';

  /// name 에 대응하는 스티커 PNG 에셋 경로(미정의 name 은 메모 스티커로 폴백). 시드/서버 데이터 호환.
  static String assetFor(String name) {
    final file = names.contains(name) ? name.toLowerCase() : 'note';
    return '$_base/$file.png';
  }
}
