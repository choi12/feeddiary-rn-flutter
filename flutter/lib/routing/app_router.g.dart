// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 앱 전역 [GoRouter]. [AuthController]의 상태를 watch 해 redirect 로 분기한다.
/// 인증 흐름: splash(부트스트랩) → unauthenticated 면 signIn/createProfile, authenticated 면 home.

@ProviderFor(appRouter)
final appRouterProvider = AppRouterProvider._();

/// 앱 전역 [GoRouter]. [AuthController]의 상태를 watch 해 redirect 로 분기한다.
/// 인증 흐름: splash(부트스트랩) → unauthenticated 면 signIn/createProfile, authenticated 면 home.

final class AppRouterProvider extends $FunctionalProvider<GoRouter, GoRouter, GoRouter> with $Provider<GoRouter> {
  /// 앱 전역 [GoRouter]. [AuthController]의 상태를 watch 해 redirect 로 분기한다.
  /// 인증 흐름: splash(부트스트랩) → unauthenticated 면 signIn/createProfile, authenticated 면 home.
  AppRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appRouterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return appRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<GoRouter>(value));
  }
}

String _$appRouterHash() => r'db1a8a25f9d9e9ae4d1b5010c414a5e00fe3d8dd';
