// CharacterCatalog — name→asset 매핑(소문자·mouse-toy 예외·폴백)·36개 목록 (unit test).
import 'package:feeddiary/ui/features/setting/character_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('캐릭터는 36개다', () {
    expect(CharacterCatalog.names.length, 36);
  });

  test('name 은 소문자 파일로 매핑된다', () {
    expect(CharacterCatalog.assetFor('Chick'), 'assets/images/character/chick.png');
    expect(CharacterCatalog.assetFor('Cat2'), 'assets/images/character/cat2.png');
  });

  test('MouseToy 만 kebab(mouse-toy) 예외다', () {
    expect(CharacterCatalog.assetFor('MouseToy'), 'assets/images/character/mouse-toy.png');
  });

  test('미정의 name 은 기본 캐릭터로 폴백한다', () {
    // 데모 community 시드의 Bear/Whale 등 미정의 name → 기본(Chick).
    expect(CharacterCatalog.assetFor('Bear'), 'assets/images/character/chick.png');
  });
}
