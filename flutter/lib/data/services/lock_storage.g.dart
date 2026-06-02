// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lock_storage.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(lockStorage)
final lockStorageProvider = LockStorageProvider._();

final class LockStorageProvider extends $FunctionalProvider<LockStorage, LockStorage, LockStorage>
    with $Provider<LockStorage> {
  LockStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lockStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lockStorageHash();

  @$internal
  @override
  $ProviderElement<LockStorage> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  LockStorage create(Ref ref) {
    return lockStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LockStorage value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<LockStorage>(value));
  }
}

String _$lockStorageHash() => r'971c95da9196033a2169e9cadd222ebf5e22671c';
