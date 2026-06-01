// 액세스 토큰 저장소 — flutter_secure_storage + in-memory 캐시. RN utils/storage/auth.ts(Keychain) 1:1.
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_storage.g.dart';

/// 액세스 토큰을 안전 저장소(Keychain/Keystore)에 보관하고, 빠른 sync 조회를 위해
/// 메모리에 캐시한다. RN `loadAccessToken`/`getAccessToken`/`setAccessToken`/`clearAccessToken` 대응.
///
/// 매 요청마다 토큰이 필요한 인터셉터(AuthInterceptor)를 위해 [token]은 sync getter 다.
/// 부팅 시 [load]로 캐시를 hydrate 한 뒤 사용한다.
class TokenStorage {
  TokenStorage(this._storage);

  static const String _key = 'feeddiary.accessToken';

  final FlutterSecureStorage _storage;
  String? _cached;

  /// 안전 저장소에서 토큰을 읽어 캐시를 채운다(부팅 1회). RN `loadAccessToken`.
  Future<void> load() async {
    try {
      _cached = await _storage.read(key: _key);
    } catch (_) {
      _cached = null;
    }
  }

  /// 캐시된 토큰(sync). RN `getAccessToken`.
  String? get token => _cached;

  /// 토큰 저장(캐시 + 안전 저장소). RN `setAccessToken`.
  Future<void> save(String token) async {
    _cached = token;
    await _storage.write(key: _key, value: token);
  }

  /// 토큰 삭제(캐시 + 안전 저장소). RN `clearAccessToken`.
  Future<void> clear() async {
    _cached = null;
    await _storage.delete(key: _key);
  }
}

@Riverpod(keepAlive: true)
TokenStorage tokenStorage(Ref ref) => TokenStorage(const FlutterSecureStorage());
