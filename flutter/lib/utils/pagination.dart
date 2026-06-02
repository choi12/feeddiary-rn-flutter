// 제네릭 오프셋 무한스크롤 — 페이지 상태 모델 + AsyncNotifier 믹스인. RN useInfiniteQuery(skip 페이지네이션) 대응.
import 'package:feeddiary/config/api_config.dart';
import 'package:feeddiary/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination.freezed.dart';

/// 오프셋 페이지네이션 누적 상태. [items]는 지금까지 로드된 전체 항목, [isEnd]는 마지막 페이지 도달 여부다.
@freezed
abstract class PagedState<T> with _$PagedState<T> {
  const factory PagedState({
    @Default(<Never>[]) List<T> items,
    @Default(false) bool isLoadingMore,
    @Default(false) bool isEnd,
  }) = _PagedState<T>;

  const PagedState._();

  bool get isEmpty => items.isEmpty;
}

/// offset 페이지네이션 로직을 제공하는 믹스인. 구현체는 [fetchPage]만 채우면 무한스크롤이 완성된다.
/// 공용 [AsyncNotifier]를 베이스로 둬 어떤 기능의 리스트에도 재사용한다(RN 의 제네릭 useInfiniteQuery 래핑 대응).
///
/// 끝 감지: 받은 페이지 길이가 [ApiConfig.itemsPerPage]보다 작으면 마지막 페이지로 본다.
mixin OffsetPagination<T> on AsyncNotifier<PagedState<T>> {
  /// 주어진 offset([skip])부터 한 페이지를 가져온다. 구현체가 repository 호출로 채운다.
  Future<List<T>> fetchPage(int skip);

  /// 첫 페이지 로드. RN useInfiniteQuery initialPageParam 0.
  Future<PagedState<T>> loadFirst() async {
    final first = await fetchPage(0);
    return PagedState(items: first, isEnd: first.length < ApiConfig.itemsPerPage);
  }

  /// 다음 페이지 로드(현재 누적 개수를 offset 으로). 로딩 중/끝/미초기화면 무시. RN getNextPageParam.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || current.isLoadingMore || current.isEnd) {
      return;
    }
    state = AsyncData(current.copyWith(isLoadingMore: true));
    try {
      final next = await fetchPage(current.items.length);
      state = AsyncData(
        current.copyWith(
          items: [...current.items, ...next],
          isLoadingMore: false,
          isEnd: next.length < ApiConfig.itemsPerPage,
        ),
      );
    } catch (error, stackTrace) {
      // 더 불러오기 실패 — 누적 항목은 유지하고 로딩만 해제(전체 에러로 떨구지 않음). RN useInfiniteQuery 거동.
      AppLogger.error('페이지 추가 로드 실패', error: error, stackTrace: stackTrace);
      state = AsyncData(current.copyWith(isLoadingMore: false));
    }
  }

  /// 처음부터 다시 로드(당겨서 새로고침). RN refetch.
  Future<void> refreshList() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(loadFirst);
  }
}
