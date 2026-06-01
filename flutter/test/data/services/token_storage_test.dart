// TokenStorage — flutter_secure_storage 플랫폼 채널 mock 으로 load/token/save/clear 캐시 검증.
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
  final store = <String, String>{};

  setUp(() {
    store.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (call) async {
      final args = (call.arguments as Map).cast<String, Object?>();
      final key = args['key'] as String?;
      switch (call.method) {
        case 'read':
          return store[key];
        case 'write':
          store[key!] = args['value'] as String;
          return null;
        case 'delete':
          store.remove(key);
          return null;
        case 'containsKey':
          return store.containsKey(key);
      }
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('초기 load 는 토큰 없음', () async {
    final ts = TokenStorage(const FlutterSecureStorage());
    await ts.load();
    expect(ts.token, isNull);
  });

  test('save 후 캐시 즉시 반영 + 재load 로 저장소에서 복원', () async {
    final ts = TokenStorage(const FlutterSecureStorage());
    await ts.save('abc123');
    expect(ts.token, 'abc123'); // sync 캐시 즉시 반영

    final fresh = TokenStorage(const FlutterSecureStorage());
    await fresh.load();
    expect(fresh.token, 'abc123'); // 저장소에서 복원
  });

  test('clear 는 캐시와 저장소를 비운다', () async {
    final ts = TokenStorage(const FlutterSecureStorage());
    await ts.save('abc123');
    await ts.clear();
    expect(ts.token, isNull);

    final fresh = TokenStorage(const FlutterSecureStorage());
    await fresh.load();
    expect(fresh.token, isNull);
  });
}
