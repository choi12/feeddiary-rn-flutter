// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_profile_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 프로필 작성 폼 컨트롤러. 닉네임은 입력 디바운스 후 정규식 → 중복검사 순으로 검증한다.
/// RN `useCheckNickname`(debounce + 정규식 + 중복검사) + `ProfileProvider`(캐릭터 선택)를 합친 ViewModel.

@ProviderFor(CreateProfileController)
final createProfileControllerProvider = CreateProfileControllerProvider._();

/// 프로필 작성 폼 컨트롤러. 닉네임은 입력 디바운스 후 정규식 → 중복검사 순으로 검증한다.
/// RN `useCheckNickname`(debounce + 정규식 + 중복검사) + `ProfileProvider`(캐릭터 선택)를 합친 ViewModel.
final class CreateProfileControllerProvider extends $NotifierProvider<CreateProfileController, CreateProfileState> {
  /// 프로필 작성 폼 컨트롤러. 닉네임은 입력 디바운스 후 정규식 → 중복검사 순으로 검증한다.
  /// RN `useCheckNickname`(debounce + 정규식 + 중복검사) + `ProfileProvider`(캐릭터 선택)를 합친 ViewModel.
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

String _$createProfileControllerHash() => r'7f96a53a6b3b3a11b4fd8235dc0e76159cfb3a5b';

/// 프로필 작성 폼 컨트롤러. 닉네임은 입력 디바운스 후 정규식 → 중복검사 순으로 검증한다.
/// RN `useCheckNickname`(debounce + 정규식 + 중복검사) + `ProfileProvider`(캐릭터 선택)를 합친 ViewModel.

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
