// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flowerpot_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(flowerpotRepository)
final flowerpotRepositoryProvider = FlowerpotRepositoryProvider._();

final class FlowerpotRepositoryProvider
    extends $FunctionalProvider<FlowerpotRepository, FlowerpotRepository, FlowerpotRepository>
    with $Provider<FlowerpotRepository> {
  FlowerpotRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'flowerpotRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$flowerpotRepositoryHash();

  @$internal
  @override
  $ProviderElement<FlowerpotRepository> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  FlowerpotRepository create(Ref ref) {
    return flowerpotRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FlowerpotRepository value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<FlowerpotRepository>(value));
  }
}

String _$flowerpotRepositoryHash() => r'cb19d5009b82a5295460f9f03699f3cedec710a0';
