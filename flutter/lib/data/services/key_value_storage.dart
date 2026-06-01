// 일반 로컬 저장소 — shared_preferences 래퍼(JSON 자동 직렬화). RN utils/storage/storage.ts(MMKV) 대응.
import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'key_value_storage.g.dart';

/// 비민감 로컬 데이터(설정·플래그 등)를 키-값으로 저장. RN `storage`(MMKV 래퍼) 대응.
/// 객체는 JSON 으로 자동 직렬화/역직렬화한다.
class KeyValueStorage {
  KeyValueStorage(this._prefs);

  final SharedPreferences _prefs;

  /// 문자열/객체 저장. 문자열이 아니면 JSON 으로 인코딩.
  Future<void> setValue(String key, Object value) {
    final encoded = value is String ? value : jsonEncode(value);
    return _prefs.setString(key, encoded);
  }

  /// 저장된 값 조회. JSON 이면 디코딩, 아니면 원문 반환.
  Object? getValue(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) {
      return null;
    }
    try {
      return jsonDecode(raw);
    } catch (_) {
      return raw;
    }
  }

  Future<void> remove(String key) => _prefs.remove(key);

  Future<void> clear() => _prefs.clear();

  bool containsKey(String key) => _prefs.containsKey(key);
}

@Riverpod(keepAlive: true)
Future<KeyValueStorage> keyValueStorage(Ref ref) async {
  final prefs = await SharedPreferences.getInstance();
  return KeyValueStorage(prefs);
}
