// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'key_value_storage.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(keyValueStorage)
final keyValueStorageProvider = KeyValueStorageProvider._();

final class KeyValueStorageProvider
    extends $FunctionalProvider<AsyncValue<KeyValueStorage>, KeyValueStorage, FutureOr<KeyValueStorage>>
    with $FutureModifier<KeyValueStorage>, $FutureProvider<KeyValueStorage> {
  KeyValueStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'keyValueStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$keyValueStorageHash();

  @$internal
  @override
  $FutureProviderElement<KeyValueStorage> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<KeyValueStorage> create(Ref ref) {
    return keyValueStorage(ref);
  }
}

String _$keyValueStorageHash() => r'2f6e105e7160633d24a1a749a71ef04eff98a278';
