// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'letter_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(letterRepository)
final letterRepositoryProvider = LetterRepositoryProvider._();

final class LetterRepositoryProvider extends $FunctionalProvider<LetterRepository, LetterRepository, LetterRepository>
    with $Provider<LetterRepository> {
  LetterRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'letterRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$letterRepositoryHash();

  @$internal
  @override
  $ProviderElement<LetterRepository> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  LetterRepository create(Ref ref) {
    return letterRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LetterRepository value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<LetterRepository>(value));
  }
}

String _$letterRepositoryHash() => r'62f741d0e9b91261c2f36d13101f90b11a271b15';
