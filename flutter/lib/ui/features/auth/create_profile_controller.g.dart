// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_profile_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 프로필 작성 폼 컨트롤러. 닉네임은 입력 디바운스 후 정규식 → 중복검사 순으로 검증하고,
/// 프로필 이미지(사진 업로드/캐릭터 프리셋)를 고른 뒤 가입한다. RN `useCheckNickname` + `ProfileProvider` + `useSignUp` ViewModel.

@ProviderFor(CreateProfileController)
final createProfileControllerProvider = CreateProfileControllerProvider._();

/// 프로필 작성 폼 컨트롤러. 닉네임은 입력 디바운스 후 정규식 → 중복검사 순으로 검증하고,
/// 프로필 이미지(사진 업로드/캐릭터 프리셋)를 고른 뒤 가입한다. RN `useCheckNickname` + `ProfileProvider` + `useSignUp` ViewModel.
final class CreateProfileControllerProvider extends $NotifierProvider<CreateProfileController, CreateProfileState> {
  /// 프로필 작성 폼 컨트롤러. 닉네임은 입력 디바운스 후 정규식 → 중복검사 순으로 검증하고,
  /// 프로필 이미지(사진 업로드/캐릭터 프리셋)를 고른 뒤 가입한다. RN `useCheckNickname` + `ProfileProvider` + `useSignUp` ViewModel.
  CreateProfileControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createProfileControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createProfileControllerHash();

  @$internal
  @override
  CreateProfileController create() => CreateProfileController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateProfileState value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<CreateProfileState>(value));
  }
}

String _$createProfileControllerHash() => r'314cf29fe60a5a84281370f96b672c5692136a23';

/// 프로필 작성 폼 컨트롤러. 닉네임은 입력 디바운스 후 정규식 → 중복검사 순으로 검증하고,
/// 프로필 이미지(사진 업로드/캐릭터 프리셋)를 고른 뒤 가입한다. RN `useCheckNickname` + `ProfileProvider` + `useSignUp` ViewModel.

abstract class _$CreateProfileController extends $Notifier<CreateProfileState> {
  CreateProfileState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<CreateProfileState, CreateProfileState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CreateProfileState, CreateProfileState>,
              CreateProfileState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
