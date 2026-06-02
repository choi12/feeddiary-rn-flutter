// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_diary_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 작성/수정 폼 컨트롤러. [initial]이 있으면 수정 모드(기존 값 시드), 없으면 새 작성.

@ProviderFor(CreateDiaryController)
final createDiaryControllerProvider = CreateDiaryControllerFamily._();

/// 작성/수정 폼 컨트롤러. [initial]이 있으면 수정 모드(기존 값 시드), 없으면 새 작성.
final class CreateDiaryControllerProvider extends $NotifierProvider<CreateDiaryController, CreateDiaryFormState> {
  /// 작성/수정 폼 컨트롤러. [initial]이 있으면 수정 모드(기존 값 시드), 없으면 새 작성.
  CreateDiaryControllerProvider._({required CreateDiaryControllerFamily super.from, required MyDiary? super.argument})
    : super(
        retry: null,
        name: r'createDiaryControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createDiaryControllerHash();

  @override
  String toString() {
    return r'createDiaryControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CreateDiaryController create() => CreateDiaryController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateDiaryFormState value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<CreateDiaryFormState>(value));
  }

  @override
  bool operator ==(Object other) {
    return other is CreateDiaryControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$createDiaryControllerHash() => r'fa743902f9d4302279ea4e28944cd3e8f0a9d061';

/// 작성/수정 폼 컨트롤러. [initial]이 있으면 수정 모드(기존 값 시드), 없으면 새 작성.

final class CreateDiaryControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          CreateDiaryController,
          CreateDiaryFormState,
          CreateDiaryFormState,
          CreateDiaryFormState,
          MyDiary?
        > {
  CreateDiaryControllerFamily._()
    : super(
        retry: null,
        name: r'createDiaryControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 작성/수정 폼 컨트롤러. [initial]이 있으면 수정 모드(기존 값 시드), 없으면 새 작성.

  CreateDiaryControllerProvider call(MyDiary? initial) =>
      CreateDiaryControllerProvider._(argument: initial, from: this);

  @override
  String toString() => r'createDiaryControllerProvider';
}

/// 작성/수정 폼 컨트롤러. [initial]이 있으면 수정 모드(기존 값 시드), 없으면 새 작성.

abstract class _$CreateDiaryController extends $Notifier<CreateDiaryFormState> {
  late final _$args = ref.$arg as MyDiary?;
  MyDiary? get initial => _$args;

  CreateDiaryFormState build(MyDiary? initial);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<CreateDiaryFormState, CreateDiaryFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CreateDiaryFormState, CreateDiaryFormState>,
              CreateDiaryFormState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
