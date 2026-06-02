// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_avatar.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 프로필 수정에서 업로드한 사진의 세션 로컬 바이트. 데모(USE_MOCK)는 실제 이미지 호스팅이 없어
/// 저장 후 서버가 URL 을 돌려주지 못하므로, 선택한 바이트를 이 keepAlive provider 에 보관해
/// 설정 프로필 박스 아바타가 세션 동안 사진을 보여주게 한다(앱 재시작 시 시드 복귀 — RN 데모와 동일한 mock 경계 한계).
///
/// PR⑤ `DiaryLikes`(글로벌 override)와 같은 패턴 — 서버 모델 밖의 클라이언트 표시 상태.

@ProviderFor(LocalAvatar)
final localAvatarProvider = LocalAvatarProvider._();

/// 프로필 수정에서 업로드한 사진의 세션 로컬 바이트. 데모(USE_MOCK)는 실제 이미지 호스팅이 없어
/// 저장 후 서버가 URL 을 돌려주지 못하므로, 선택한 바이트를 이 keepAlive provider 에 보관해
/// 설정 프로필 박스 아바타가 세션 동안 사진을 보여주게 한다(앱 재시작 시 시드 복귀 — RN 데모와 동일한 mock 경계 한계).
///
/// PR⑤ `DiaryLikes`(글로벌 override)와 같은 패턴 — 서버 모델 밖의 클라이언트 표시 상태.
final class LocalAvatarProvider extends $NotifierProvider<LocalAvatar, Uint8List?> {
  /// 프로필 수정에서 업로드한 사진의 세션 로컬 바이트. 데모(USE_MOCK)는 실제 이미지 호스팅이 없어
  /// 저장 후 서버가 URL 을 돌려주지 못하므로, 선택한 바이트를 이 keepAlive provider 에 보관해
  /// 설정 프로필 박스 아바타가 세션 동안 사진을 보여주게 한다(앱 재시작 시 시드 복귀 — RN 데모와 동일한 mock 경계 한계).
  ///
  /// PR⑤ `DiaryLikes`(글로벌 override)와 같은 패턴 — 서버 모델 밖의 클라이언트 표시 상태.
  LocalAvatarProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localAvatarProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localAvatarHash();

  @$internal
  @override
  LocalAvatar create() => LocalAvatar();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Uint8List? value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Uint8List?>(value));
  }
}

String _$localAvatarHash() => r'abd84196acec3494d06d22105ee78891de1d940f';

/// 프로필 수정에서 업로드한 사진의 세션 로컬 바이트. 데모(USE_MOCK)는 실제 이미지 호스팅이 없어
/// 저장 후 서버가 URL 을 돌려주지 못하므로, 선택한 바이트를 이 keepAlive provider 에 보관해
/// 설정 프로필 박스 아바타가 세션 동안 사진을 보여주게 한다(앱 재시작 시 시드 복귀 — RN 데모와 동일한 mock 경계 한계).
///
/// PR⑤ `DiaryLikes`(글로벌 override)와 같은 패턴 — 서버 모델 밖의 클라이언트 표시 상태.

abstract class _$LocalAvatar extends $Notifier<Uint8List?> {
  Uint8List? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Uint8List?, Uint8List?>;
    final element =
        ref.element as $ClassProviderElement<AnyNotifier<Uint8List?, Uint8List?>, Uint8List?, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
