// 캐릭터 카탈로그 — 프로필 캐릭터 name 을 번들 PNG 에셋 경로로 매핑. RN CharacterBox/data.ts 1:1, 저장값은 name 문자열 유지.
abstract final class CharacterCatalog {
  static const String _base = 'assets/images/character';

  /// 선택 가능한 캐릭터 name 목록(프로필 수정 그리드 순서). RN `CHARACTER_ICONS`(6×6) flat 순서 1:1.
  /// 파일명은 `name.toLowerCase().png`이며, `MouseToy`만 `mouse-toy.png`(아래 [_fileFor]에서 예외 처리).
  static const List<String> names = [
    'Bat',
    'Bird',
    'Bull',
    'Cat',
    'Cat2',
    'Cat3',
    'Caterpillar',
    'Chick',
    'Chicken',
    'Chihuahua',
    'Dalmatian',
    'Deer',
    'Dog',
    'Dog2',
    'Dog3',
    'Fox',
    'Fox2',
    'Frog',
    'Groundhog',
    'Groundhog2',
    'Hamster',
    'Hamster2',
    'Hedgehog',
    'Husky',
    'Ladybug',
    'MouseToy',
    'Panda',
    'Pomeranian',
    'Rabbit',
    'Rabbit2',
    'Rabbit3',
    'Raccoon',
    'Reindeer',
    'Silk',
    'Spitz',
    'Squirrel',
  ];

  /// 회원가입 기본 캐릭터(데모 시드와 동일). RN 데모 사용자 character.
  static const String defaultName = 'Chick';

  /// name 에 대응하는 캐릭터 PNG 에셋 경로(미정의 name 은 기본 캐릭터로 폴백). 시드/서버 데이터 호환.
  static String assetFor(String name) {
    final resolved = names.contains(name) ? name : defaultName;
    return '$_base/${_fileFor(resolved)}.png';
  }

  /// name → 파일명. 대부분 소문자이나 `MouseToy`는 kebab(`mouse-toy`)만 예외.
  static String _fileFor(String name) => name == 'MouseToy' ? 'mouse-toy' : name.toLowerCase();
}
