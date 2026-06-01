// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 앱 전역 [GoRouter]. [AuthController]의 상태를 watch 해 redirect 로 분기한다.
/// PR① 골격 — 라우트 타겟은 모두 [PlaceholderPage]이고, 실제 화면은 기능 PR에서 채운다.

@ProviderFor(appRouter)
final appRouterProvider = AppRouterProvider._();

/// 앱 전역 [GoRouter]. [AuthController]의 상태를 watch 해 redirect 로 분기한다.
/// PR① 골격 — 라우트 타겟은 모두 [PlaceholderPage]이고, 실제 화면은 기능 PR에서 채운다.

final class AppRouterProvider extends $FunctionalProvider<GoRouter, GoRouter, GoRouter> with $Provider<GoRouter> {
  /// 앱 전역 [GoRouter]. [AuthController]의 상태를 watch 해 redirect 로 분기한다.
  /// PR① 골격 — 라우트 타겟은 모두 [PlaceholderPage]이고, 실제 화면은 기능 PR에서 채운다.
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

String _$appRouterHash() => r'262824bdc537c191a04bf988972c88a64ed342fa';
