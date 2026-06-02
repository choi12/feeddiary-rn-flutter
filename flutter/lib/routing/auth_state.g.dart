// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 인증 흐름을 조율하는 컨트롤러. RN `useSignIn`/`useSignUp`/`useSignOut` 의 오케스트레이션을
/// 하나의 Riverpod Notifier 로 모은다. [build]는 [AuthStatus.unknown]을 반환하고, 실제 세션 복원은
/// splash 화면이 [restore]를 트리거한다(RN `Update` 화면이 `useAppUpdate` 로 트리거하는 것과 대응).

@ProviderFor(AuthController)
final authControllerProvider = AuthControllerProvider._();

/// 인증 흐름을 조율하는 컨트롤러. RN `useSignIn`/`useSignUp`/`useSignOut` 의 오케스트레이션을
/// 하나의 Riverpod Notifier 로 모은다. [build]는 [AuthStatus.unknown]을 반환하고, 실제 세션 복원은
/// splash 화면이 [restore]를 트리거한다(RN `Update` 화면이 `useAppUpdate` 로 트리거하는 것과 대응).
final class AuthControllerProvider extends $NotifierProvider<AuthController, AuthState> {
  /// 인증 흐름을 조율하는 컨트롤러. RN `useSignIn`/`useSignUp`/`useSignOut` 의 오케스트레이션을
  /// 하나의 Riverpod Notifier 로 모은다. [build]는 [AuthStatus.unknown]을 반환하고, 실제 세션 복원은
  /// splash 화면이 [restore]를 트리거한다(RN `Update` 화면이 `useAppUpdate` 로 트리거하는 것과 대응).
  AuthControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authControllerHash();

  @$internal
  @override
  AuthController create() => AuthController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthState value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<AuthState>(value));
  }
}

String _$authControllerHash() => r'ed595bc930f009e03f94ec7eb4a3b5b0a3b9bd42';

/// 인증 흐름을 조율하는 컨트롤러. RN `useSignIn`/`useSignUp`/`useSignOut` 의 오케스트레이션을
/// 하나의 Riverpod Notifier 로 모은다. [build]는 [AuthStatus.unknown]을 반환하고, 실제 세션 복원은
/// splash 화면이 [restore]를 트리거한다(RN `Update` 화면이 `useAppUpdate` 로 트리거하는 것과 대응).

abstract class _$AuthController extends $Notifier<AuthState> {
  AuthState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AuthState, AuthState>;
    final element =
        ref.element as $ClassProviderElement<AnyNotifier<AuthState, AuthState>, AuthState, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
