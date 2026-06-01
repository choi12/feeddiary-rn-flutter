// KeyValueStorage — SharedPreferences mock 으로 set/get/remove/clear + JSON 직렬화 검증.
import 'package:feeddiary/data/services/key_value_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late KeyValueStorage storage;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    storage = KeyValueStorage(prefs);
  });

  test('문자열 set/get', () async {
    await storage.setValue('name', '새싹이');
    expect(storage.getValue('name'), '새싹이');
  });

  test('객체는 JSON 으로 직렬화/역직렬화', () async {
    await storage.setValue('user', {'id': 1, 'nick': '새싹이'});
    expect(storage.getValue('user'), {'id': 1, 'nick': '새싹이'});
  });

  test('remove 와 containsKey', () async {
    await storage.setValue('flag', 'on');
    expect(storage.containsKey('flag'), isTrue);
    await storage.remove('flag');
    expect(storage.containsKey('flag'), isFalse);
  });

  test('없는 키는 null', () {
    expect(storage.getValue('missing'), isNull);
  });
}
