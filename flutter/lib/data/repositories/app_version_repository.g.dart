// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_version_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appVersionRepository)
final appVersionRepositoryProvider = AppVersionRepositoryProvider._();

final class AppVersionRepositoryProvider
    extends $FunctionalProvider<AppVersionRepository, AppVersionRepository, AppVersionRepository>
    with $Provider<AppVersionRepository> {
  AppVersionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appVersionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appVersionRepositoryHash();

  @$internal
  @override
  $ProviderElement<AppVersionRepository> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  AppVersionRepository create(Ref ref) {
    return appVersionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppVersionRepository value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<AppVersionRepository>(value));
  }
}

String _$appVersionRepositoryHash() => r'c246a51e3bc9df8095b9fdc412a159a92bd005d4';

/// 최신 앱 버전(서버상태). RN React Query 패턴 대응 — cacheFor 로 gcTime 을 적용하고,
/// 갱신은 `ref.invalidate(latestAppVersionProvider)`로 수행한다.

@ProviderFor(latestAppVersion)
final latestAppVersionProvider = LatestAppVersionProvider._();

/// 최신 앱 버전(서버상태). RN React Query 패턴 대응 — cacheFor 로 gcTime 을 적용하고,
/// 갱신은 `ref.invalidate(latestAppVersionProvider)`로 수행한다.

final class LatestAppVersionProvider extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// 최신 앱 버전(서버상태). RN React Query 패턴 대응 — cacheFor 로 gcTime 을 적용하고,
  /// 갱신은 `ref.invalidate(latestAppVersionProvider)`로 수행한다.
  LatestAppVersionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'latestAppVersionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$latestAppVersionHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return latestAppVersion(ref);
  }
}

String _$latestAppVersionHash() => r'19879b9e64b17a246b5048db244607381fc72e85';
