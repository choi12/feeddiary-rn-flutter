// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 현재 인증 상태를 노출하는 Notifier. 지금은 [AuthStatus.unauthenticated] 고정 placeholder이며,
/// auth PR에서 토큰 저장소·세션 복원 로직으로 대체한다. GoRouter redirect 가 이 값을 watch 한다.

@ProviderFor(AuthController)
final authControllerProvider = AuthControllerProvider._();

/// 현재 인증 상태를 노출하는 Notifier. 지금은 [AuthStatus.unauthenticated] 고정 placeholder이며,
/// auth PR에서 토큰 저장소·세션 복원 로직으로 대체한다. GoRouter redirect 가 이 값을 watch 한다.
final class AuthControllerProvider extends $NotifierProvider<AuthController, AuthStatus> {
  /// 현재 인증 상태를 노출하는 Notifier. 지금은 [AuthStatus.unauthenticated] 고정 placeholder이며,
  /// auth PR에서 토큰 저장소·세션 복원 로직으로 대체한다. GoRouter redirect 가 이 값을 watch 한다.
  AuthControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authControllerHash();

  @$internal
  @override
  AuthController create() => AuthController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthStatus value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<AuthStatus>(value));
  }
}

String _$authControllerHash() => r'8aba8fded08736cfd729f8909c3372d6360f68fd';

/// 현재 인증 상태를 노출하는 Notifier. 지금은 [AuthStatus.unauthenticated] 고정 placeholder이며,
/// auth PR에서 토큰 저장소·세션 복원 로직으로 대체한다. GoRouter redirect 가 이 값을 watch 한다.

abstract class _$AuthController extends $Notifier<AuthStatus> {
  AuthStatus build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AuthStatus, AuthStatus>;
    final element =
        ref.element as $ClassProviderElement<AnyNotifier<AuthStatus, AuthStatus>, AuthStatus, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
