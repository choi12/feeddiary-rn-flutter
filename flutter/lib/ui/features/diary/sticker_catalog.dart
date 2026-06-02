// 스티커 카탈로그 — 백엔드 스티커 name 을 데모용 이모지로 매핑(RN PNG 자산은 RN 전용). 저장값은 name 문자열 유지.
abstract final class StickerCatalog {
  /// 백엔드 스티커 name → 표시용 이모지. RN CreateDiary/data.ts STICKER_ICONS 의 부분집합.
  static const Map<String, String> emojis = {
    'CloudSun': '⛅',
    'Star': '⭐',
    'Snow': '❄️',
    'Rainbow': '🌈',
    'Rain': '🌧️',
    'Thunder': '⚡',
    'Moon': '🌙',
    'Sunny': '☀️',
    'Coffee': '☕',
    'Flower': '🌸',
    'Happiness': '😊',
    'Sleep': '😴',
    'Smile': '🙂',
    'Thinking': '🤔',
    'Restaurant': '🍽️',
    'Video': '🎬',
  };

  /// 작성 폼 기본 스티커. RN STICKER_ICONS[0].
  static const String defaultName = 'CloudSun';

  /// 선택 가능한 스티커 name 목록(작성 화면 그리드 순서).
  static List<String> get names => emojis.keys.toList();

  /// name 에 대응하는 이모지(미정의 name 은 메모 이모지로 폴백). 시드/서버 데이터 호환.
  static String emojiFor(String name) => emojis[name] ?? '📝';
}
