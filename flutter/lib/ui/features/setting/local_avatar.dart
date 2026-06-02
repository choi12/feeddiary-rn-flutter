// 세션 프로필 사진 override — 데모는 이미지 호스팅이 없어 업로드한 사진을 인메모리로 보관해 아바타에 표시.
import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_avatar.g.dart';

/// 프로필 수정에서 업로드한 사진의 세션 로컬 바이트. 데모(USE_MOCK)는 실제 이미지 호스팅이 없어
/// 저장 후 서버가 URL 을 돌려주지 못하므로, 선택한 바이트를 이 keepAlive provider 에 보관해
/// 설정 프로필 박스 아바타가 세션 동안 사진을 보여주게 한다(앱 재시작 시 시드 복귀 — RN 데모와 동일한 mock 경계 한계).
///
/// PR⑤ `DiaryLikes`(글로벌 override)와 같은 패턴 — 서버 모델 밖의 클라이언트 표시 상태.
@Riverpod(keepAlive: true)
class LocalAvatar extends _$LocalAvatar {
  @override
  Uint8List? build() => null;

  /// 사진 선택/저장 시 바이트 설정.
  void set(Uint8List bytes) => state = bytes;

  /// 캐릭터로 전환하거나 로그아웃할 때 해제.
  void clear() => state = null;
}
