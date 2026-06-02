// 앱 잠금 저장소 — 비밀번호(secure)·사용 플래그 + in-memory 캐시. RN utils/storage/lock.ts(MMKV) 1:1.
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lock_storage.g.dart';

/// 앱 잠금(A-6) 로컬 저장소. 비밀번호는 안전 저장소(Keychain/Keystore)에 보관하고,
/// 라이프사이클 가드가 resume 마다 sync 로 검사할 수 있도록 사용 여부/비밀번호를 메모리에 캐시한다.
///
/// 부팅 시 [load]로 캐시를 hydrate 한 뒤 사용한다(TokenStorage 와 동일 패턴).
/// RN `setLockPassword`/`enableLock`/`disableLock`/`getUseLock`/`getLockPassword` 대응.
class LockStorage {
  LockStorage(this._storage);

  static const String _passwordKey = 'feeddiary.lock.password';
  static const String _enabledKey = 'feeddiary.lock.enabled';

  final FlutterSecureStorage _storage;
  bool _useLock = false;
  String? _password;

  /// 안전 저장소에서 잠금 상태를 읽어 캐시를 채운다(부팅 1회). RN 저장소 sync 거동 재현.
  Future<void> load() async {
    try {
      _password = await _storage.read(key: _passwordKey);
      _useLock = (await _storage.read(key: _enabledKey)) == 'true';
    } catch (_) {
      _password = null;
      _useLock = false;
    }
  }

  /// 잠금 사용 여부(sync). RN `getUseLock`.
  bool get useLock => _useLock;

  /// 비밀번호가 설정되어 있는지(sync). RN `getLockPassword() != null`.
  bool get hasPassword => _password != null && _password!.isNotEmpty;

  /// 입력값이 저장된 비밀번호와 일치하는지. RN 잠금 해제 검증.
  bool verify(String input) => hasPassword && input == _password;

  /// 비밀번호 저장(캐시 + 안전 저장소, 평문 금지라 secure). RN `setLockPassword`.
  Future<void> setPassword(String value) async {
    _password = value;
    await _storage.write(key: _passwordKey, value: value);
  }

  /// 잠금 사용 켜기. RN `enableLock`.
  Future<void> enableLock() async {
    _useLock = true;
    await _storage.write(key: _enabledKey, value: 'true');
  }

  /// 잠금 사용 끄기(플래그 삭제). RN `disableLock`.
  Future<void> disableLock() async {
    _useLock = false;
    await _storage.delete(key: _enabledKey);
  }
}

@Riverpod(keepAlive: true)
LockStorage lockStorage(Ref ref) => LockStorage(const FlutterSecureStorage());
