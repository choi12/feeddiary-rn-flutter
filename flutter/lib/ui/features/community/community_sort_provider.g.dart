// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_sort_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 현재 community 정렬 기준. 화면(SegmentedButton)과 목록 컨트롤러가 공유하는 작은 클라이언트 상태다.

@ProviderFor(CommunitySortController)
final communitySortControllerProvider = CommunitySortControllerProvider._();

/// 현재 community 정렬 기준. 화면(SegmentedButton)과 목록 컨트롤러가 공유하는 작은 클라이언트 상태다.
final class CommunitySortControllerProvider extends $NotifierProvider<CommunitySortController, CommunitySort> {
  /// 현재 community 정렬 기준. 화면(SegmentedButton)과 목록 컨트롤러가 공유하는 작은 클라이언트 상태다.
  CommunitySortControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'communitySortControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$communitySortControllerHash();

  @$internal
  @override
  CommunitySortController create() => CommunitySortController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CommunitySort value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<CommunitySort>(value));
  }
}

String _$communitySortControllerHash() => r'9db66e16e2a1b9f3037aaf053f5b4331af8b9da4';

/// 현재 community 정렬 기준. 화면(SegmentedButton)과 목록 컨트롤러가 공유하는 작은 클라이언트 상태다.

abstract class _$CommunitySortController extends $Notifier<CommunitySort> {
  CommunitySort build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<CommunitySort, CommunitySort>;
    final element =
        ref.element
            as $ClassProviderElement<AnyNotifier<CommunitySort, CommunitySort>, CommunitySort, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
