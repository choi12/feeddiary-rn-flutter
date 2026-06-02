// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_likes.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 좋아요 글로벌 override 저장소. 같은 일기가 community 목록 카드와 상세에 동시 등장하므로,
/// 좋아요를 화면 로컬이 아닌 이 keepAlive provider 한 곳에 모아 양쪽이 같은 소스를 구독한다
/// (flutter/CLAUDE.md "유저 관계 상태=글로벌 Provider"). override 가 없으면 위젯은 서버값(base)을 그대로 쓴다.
///
/// RN 은 좋아요 후 DIARY·COMMUNITY 쿼리를 invalidate 해 동기화하지만, 우리 무한리스트(OffsetPagination)는
/// 부분 재조회가 불가해 invalidate 시 1페이지로 리셋된다. override 방식이 리스트 누적·스크롤을 보존한다.

@ProviderFor(DiaryLikes)
final diaryLikesProvider = DiaryLikesProvider._();

/// 좋아요 글로벌 override 저장소. 같은 일기가 community 목록 카드와 상세에 동시 등장하므로,
/// 좋아요를 화면 로컬이 아닌 이 keepAlive provider 한 곳에 모아 양쪽이 같은 소스를 구독한다
/// (flutter/CLAUDE.md "유저 관계 상태=글로벌 Provider"). override 가 없으면 위젯은 서버값(base)을 그대로 쓴다.
///
/// RN 은 좋아요 후 DIARY·COMMUNITY 쿼리를 invalidate 해 동기화하지만, 우리 무한리스트(OffsetPagination)는
/// 부분 재조회가 불가해 invalidate 시 1페이지로 리셋된다. override 방식이 리스트 누적·스크롤을 보존한다.
final class DiaryLikesProvider extends $NotifierProvider<DiaryLikes, Map<int, LikeState>> {
  /// 좋아요 글로벌 override 저장소. 같은 일기가 community 목록 카드와 상세에 동시 등장하므로,
  /// 좋아요를 화면 로컬이 아닌 이 keepAlive provider 한 곳에 모아 양쪽이 같은 소스를 구독한다
  /// (flutter/CLAUDE.md "유저 관계 상태=글로벌 Provider"). override 가 없으면 위젯은 서버값(base)을 그대로 쓴다.
  ///
  /// RN 은 좋아요 후 DIARY·COMMUNITY 쿼리를 invalidate 해 동기화하지만, 우리 무한리스트(OffsetPagination)는
  /// 부분 재조회가 불가해 invalidate 시 1페이지로 리셋된다. override 방식이 리스트 누적·스크롤을 보존한다.
  DiaryLikesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diaryLikesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diaryLikesHash();

  @$internal
  @override
  DiaryLikes create() => DiaryLikes();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<int, LikeState> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Map<int, LikeState>>(value));
  }
}

String _$diaryLikesHash() => r'982eb90209a20a6a23af3013a7c9d81fe12749ec';

/// 좋아요 글로벌 override 저장소. 같은 일기가 community 목록 카드와 상세에 동시 등장하므로,
/// 좋아요를 화면 로컬이 아닌 이 keepAlive provider 한 곳에 모아 양쪽이 같은 소스를 구독한다
/// (flutter/CLAUDE.md "유저 관계 상태=글로벌 Provider"). override 가 없으면 위젯은 서버값(base)을 그대로 쓴다.
///
/// RN 은 좋아요 후 DIARY·COMMUNITY 쿼리를 invalidate 해 동기화하지만, 우리 무한리스트(OffsetPagination)는
/// 부분 재조회가 불가해 invalidate 시 1페이지로 리셋된다. override 방식이 리스트 누적·스크롤을 보존한다.

abstract class _$DiaryLikes extends $Notifier<Map<int, LikeState>> {
  Map<int, LikeState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Map<int, LikeState>, Map<int, LikeState>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<int, LikeState>, Map<int, LikeState>>,
              Map<int, LikeState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
