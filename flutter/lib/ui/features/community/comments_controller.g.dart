// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comments_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 특정 일기의 댓글 목록 + 작성/삭제. 타인 액션 반영 가능성으로 realtime 캐시한다.
/// 작성은 비낙관(성공 후 재조회 — 서버 idx/시각 확정), 삭제는 낙관 제거 후 실패 시 롤백한다(RN 거동).

@ProviderFor(CommentsController)
final commentsControllerProvider = CommentsControllerFamily._();

/// 특정 일기의 댓글 목록 + 작성/삭제. 타인 액션 반영 가능성으로 realtime 캐시한다.
/// 작성은 비낙관(성공 후 재조회 — 서버 idx/시각 확정), 삭제는 낙관 제거 후 실패 시 롤백한다(RN 거동).
final class CommentsControllerProvider extends $AsyncNotifierProvider<CommentsController, List<Comment>> {
  /// 특정 일기의 댓글 목록 + 작성/삭제. 타인 액션 반영 가능성으로 realtime 캐시한다.
  /// 작성은 비낙관(성공 후 재조회 — 서버 idx/시각 확정), 삭제는 낙관 제거 후 실패 시 롤백한다(RN 거동).
  CommentsControllerProvider._({required CommentsControllerFamily super.from, required int super.argument})
    : super(
        retry: null,
        name: r'commentsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$commentsControllerHash();

  @override
  String toString() {
    return r'commentsControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CommentsController create() => CommentsController();

  @override
  bool operator ==(Object other) {
    return other is CommentsControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$commentsControllerHash() => r'120718d21509459f3b292bfc93b7fc9b7486bddb';

/// 특정 일기의 댓글 목록 + 작성/삭제. 타인 액션 반영 가능성으로 realtime 캐시한다.
/// 작성은 비낙관(성공 후 재조회 — 서버 idx/시각 확정), 삭제는 낙관 제거 후 실패 시 롤백한다(RN 거동).

final class CommentsControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          CommentsController,
          AsyncValue<List<Comment>>,
          List<Comment>,
          FutureOr<List<Comment>>,
          int
        > {
  CommentsControllerFamily._()
    : super(
        retry: null,
        name: r'commentsControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 특정 일기의 댓글 목록 + 작성/삭제. 타인 액션 반영 가능성으로 realtime 캐시한다.
  /// 작성은 비낙관(성공 후 재조회 — 서버 idx/시각 확정), 삭제는 낙관 제거 후 실패 시 롤백한다(RN 거동).

  CommentsControllerProvider call(int diaryIdx) => CommentsControllerProvider._(argument: diaryIdx, from: this);

  @override
  String toString() => r'commentsControllerProvider';
}

/// 특정 일기의 댓글 목록 + 작성/삭제. 타인 액션 반영 가능성으로 realtime 캐시한다.
/// 작성은 비낙관(성공 후 재조회 — 서버 idx/시각 확정), 삭제는 낙관 제거 후 실패 시 롤백한다(RN 거동).

abstract class _$CommentsController extends $AsyncNotifier<List<Comment>> {
  late final _$args = ref.$arg as int;
  int get diaryIdx => _$args;

  FutureOr<List<Comment>> build(int diaryIdx);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Comment>>, List<Comment>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Comment>>, List<Comment>>,
              AsyncValue<List<Comment>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
