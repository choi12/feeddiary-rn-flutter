// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 일기 상세 상태. 공개여부는 낙관적으로 즉시 반영하고 실패 시 이전 상태로 되돌린다
/// (RN useOptimistic). 좋아요는 목록↔상세 동기화를 위해 `DiaryLikes` 글로벌 provider 가 담당한다.
/// 타인 액션 반영 가능성으로 realtime 캐시.

@ProviderFor(DiaryDetailController)
final diaryDetailControllerProvider = DiaryDetailControllerFamily._();

/// 일기 상세 상태. 공개여부는 낙관적으로 즉시 반영하고 실패 시 이전 상태로 되돌린다
/// (RN useOptimistic). 좋아요는 목록↔상세 동기화를 위해 `DiaryLikes` 글로벌 provider 가 담당한다.
/// 타인 액션 반영 가능성으로 realtime 캐시.
final class DiaryDetailControllerProvider extends $AsyncNotifierProvider<DiaryDetailController, CommunityDiary> {
  /// 일기 상세 상태. 공개여부는 낙관적으로 즉시 반영하고 실패 시 이전 상태로 되돌린다
  /// (RN useOptimistic). 좋아요는 목록↔상세 동기화를 위해 `DiaryLikes` 글로벌 provider 가 담당한다.
  /// 타인 액션 반영 가능성으로 realtime 캐시.
  DiaryDetailControllerProvider._({required DiaryDetailControllerFamily super.from, required int super.argument})
    : super(
        retry: null,
        name: r'diaryDetailControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diaryDetailControllerHash();

  @override
  String toString() {
    return r'diaryDetailControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DiaryDetailController create() => DiaryDetailController();

  @override
  bool operator ==(Object other) {
    return other is DiaryDetailControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$diaryDetailControllerHash() => r'3590ba909c4f74343d5c859ddfdb416f02a6deb8';

/// 일기 상세 상태. 공개여부는 낙관적으로 즉시 반영하고 실패 시 이전 상태로 되돌린다
/// (RN useOptimistic). 좋아요는 목록↔상세 동기화를 위해 `DiaryLikes` 글로벌 provider 가 담당한다.
/// 타인 액션 반영 가능성으로 realtime 캐시.

final class DiaryDetailControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          DiaryDetailController,
          AsyncValue<CommunityDiary>,
          CommunityDiary,
          FutureOr<CommunityDiary>,
          int
        > {
  DiaryDetailControllerFamily._()
    : super(
        retry: null,
        name: r'diaryDetailControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 일기 상세 상태. 공개여부는 낙관적으로 즉시 반영하고 실패 시 이전 상태로 되돌린다
  /// (RN useOptimistic). 좋아요는 목록↔상세 동기화를 위해 `DiaryLikes` 글로벌 provider 가 담당한다.
  /// 타인 액션 반영 가능성으로 realtime 캐시.

  DiaryDetailControllerProvider call(int diaryIdx) => DiaryDetailControllerProvider._(argument: diaryIdx, from: this);

  @override
  String toString() => r'diaryDetailControllerProvider';
}

/// 일기 상세 상태. 공개여부는 낙관적으로 즉시 반영하고 실패 시 이전 상태로 되돌린다
/// (RN useOptimistic). 좋아요는 목록↔상세 동기화를 위해 `DiaryLikes` 글로벌 provider 가 담당한다.
/// 타인 액션 반영 가능성으로 realtime 캐시.

abstract class _$DiaryDetailController extends $AsyncNotifier<CommunityDiary> {
  late final _$args = ref.$arg as int;
  int get diaryIdx => _$args;

  FutureOr<CommunityDiary> build(int diaryIdx);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<CommunityDiary>, CommunityDiary>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CommunityDiary>, CommunityDiary>,
              AsyncValue<CommunityDiary>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
