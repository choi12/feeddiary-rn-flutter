// LockStorage — flutter_secure_storage 채널 mock 으로 useLock 플래그·비밀번호·검증·재load 캐시 검증 (provider/unit).
import 'package:feeddiary/data/services/lock_storage.dart';
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

  test('초기 load 는 잠금 꺼짐·비밀번호 없음', () async {
    final lock = LockStorage(const FlutterSecureStorage());
    await lock.load();
    expect(lock.useLock, isFalse);
    expect(lock.hasPassword, isFalse);
  });

  test('enableLock 후 useLock true, 재load 로 복원된다', () async {
    final lock = LockStorage(const FlutterSecureStorage());
    await lock.enableLock();
    expect(lock.useLock, isTrue);

    final fresh = LockStorage(const FlutterSecureStorage());
    await fresh.load();
    expect(fresh.useLock, isTrue);
  });

  test('disableLock 은 플래그를 지운다', () async {
    final lock = LockStorage(const FlutterSecureStorage());
    await lock.enableLock();
    await lock.disableLock();
    expect(lock.useLock, isFalse);

    final fresh = LockStorage(const FlutterSecureStorage());
    await fresh.load();
    expect(fresh.useLock, isFalse);
  });

  test('setPassword 후 일치/불일치 검증 + 재load 복원', () async {
    final lock = LockStorage(const FlutterSecureStorage());
    await lock.setPassword('1234');
    expect(lock.hasPassword, isTrue);
    expect(lock.verify('1234'), isTrue);
    expect(lock.verify('0000'), isFalse);

    final fresh = LockStorage(const FlutterSecureStorage());
    await fresh.load();
    expect(fresh.verify('1234'), isTrue);
  });

  test('비밀번호 미설정이면 verify 는 항상 false', () async {
    final lock = LockStorage(const FlutterSecureStorage());
    await lock.load();
    expect(lock.verify('1234'), isFalse);
  });
}
