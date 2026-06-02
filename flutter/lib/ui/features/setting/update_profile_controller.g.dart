// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_profile_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 프로필 수정 폼 컨트롤러. 닉네임은 디바운스 후 검증(CreateProfile 과 동일 로직 재사용)하고,
/// 사진/캐릭터/배경 변경을 추적한다. RN `useUpdateProfile`(변경 감지·FormData) + `useCheckNickname` ViewModel.

@ProviderFor(UpdateProfileController)
final updateProfileControllerProvider = UpdateProfileControllerProvider._();

/// 프로필 수정 폼 컨트롤러. 닉네임은 디바운스 후 검증(CreateProfile 과 동일 로직 재사용)하고,
/// 사진/캐릭터/배경 변경을 추적한다. RN `useUpdateProfile`(변경 감지·FormData) + `useCheckNickname` ViewModel.
final class UpdateProfileControllerProvider extends $NotifierProvider<UpdateProfileController, UpdateProfileState> {
  /// 프로필 수정 폼 컨트롤러. 닉네임은 디바운스 후 검증(CreateProfile 과 동일 로직 재사용)하고,
  /// 사진/캐릭터/배경 변경을 추적한다. RN `useUpdateProfile`(변경 감지·FormData) + `useCheckNickname` ViewModel.
  UpdateProfileControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateProfileControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateProfileControllerHash();

  @$internal
  @override
  UpdateProfileController create() => UpdateProfileController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateProfileState value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<UpdateProfileState>(value));
  }
}

String _$updateProfileControllerHash() => r'508625b2b3200b3d79fd58b45f6409c33c961a50';

/// 프로필 수정 폼 컨트롤러. 닉네임은 디바운스 후 검증(CreateProfile 과 동일 로직 재사용)하고,
/// 사진/캐릭터/배경 변경을 추적한다. RN `useUpdateProfile`(변경 감지·FormData) + `useCheckNickname` ViewModel.

abstract class _$UpdateProfileController extends $Notifier<UpdateProfileState> {
  UpdateProfileState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<UpdateProfileState, UpdateProfileState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UpdateProfileState, UpdateProfileState>,
              UpdateProfileState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
