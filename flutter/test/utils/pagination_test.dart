// OffsetPagination 믹스인 — 페이지 누적·끝 감지·loadMore 가드 (Provider/Notifier test, fake fetchPage).
import 'dart:async';

import 'package:feeddiary/utils/pagination.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// fetchPage 를 미리 준비한 페이지로 채우는 테스트용 Notifier.
class _FakeNotifier extends AsyncNotifier<PagedState<int>> with OffsetPagination<int> {
  _FakeNotifier(this.pages);

  final List<List<int>> pages;
  int calls = 0;

  @override
  Future<PagedState<int>> build() => loadFirst();

  @override
  Future<List<int>> fetchPage(int skip) async {
    final page = calls < pages.length ? pages[calls] : <int>[];
    calls++;
    return page;
  }
}

/// fetchPage 응답을 테스트가 직접 풀어 주는 Notifier — 요청이 겹치는 순서를 재현한다.
class _GatedNotifier extends AsyncNotifier<PagedState<int>> with OffsetPagination<int> {
  final gates = <Completer<List<int>>>[];

  @override
  Future<PagedState<int>> build() => loadFirst();

  @override
  Future<List<int>> fetchPage(int skip) {
    final gate = Completer<List<int>>();
    gates.add(gate);
    return gate.future;
  }
}

List<int> _page(int from) => List.generate(10, (i) => from + i);

void main() {
  AsyncNotifierProvider<_FakeNotifier, PagedState<int>> providerOf(List<List<int>> pages) {
    return AsyncNotifierProvider<_FakeNotifier, PagedState<int>>(() => _FakeNotifier(pages));
  }

  test('첫 페이지가 itemsPerPage 미만이면 즉시 끝으로 본다', () async {
    final provider = providerOf([
      [1, 2, 3],
    ]);
    final container = ProviderContainer(retry: (_, _) => null);
    addTearDown(container.dispose);

    final first = await container.read(provider.future);
    expect(first.items, [1, 2, 3]);
    expect(first.isEnd, true);
  });

  test('loadMore 가 페이지를 누적하고 마지막 페이지에서 끝을 감지한다', () async {
    final provider = providerOf([List.generate(10, (i) => i), List.generate(5, (i) => i + 10)]);
    final container = ProviderContainer(retry: (_, _) => null);
    addTearDown(container.dispose);

    final first = await container.read(provider.future);
    expect(first.items.length, 10);
    expect(first.isEnd, false);

    await container.read(provider.notifier).loadMore();
    final after = container.read(provider).value!;
    expect(after.items.length, 15);
    expect(after.isEnd, true);
  });

  test('끝에 도달하면 loadMore 는 추가 fetch 없이 무시된다', () async {
    final provider = providerOf([
      [1, 2],
    ]);
    final container = ProviderContainer(retry: (_, _) => null);
    addTearDown(container.dispose);

    await container.read(provider.future);
    final notifier = container.read(provider.notifier);
    await notifier.loadMore();
    expect(notifier.calls, 1); // build 의 loadFirst 1회만
    expect(container.read(provider).value!.items.length, 2);
  });

  group('loadMore 응답이 늦게 올 때', () {
    final provider = AsyncNotifierProvider<_GatedNotifier, PagedState<int>>(_GatedNotifier.new);
    late ProviderContainer container;

    Future<_GatedNotifier> loadFirstPage() async {
      container = ProviderContainer(retry: (_, _) => null);
      addTearDown(container.dispose);
      container.listen(provider, (_, _) {});
      final notifier = container.read(provider.notifier);
      notifier.gates.single.complete(_page(0));
      await container.read(provider.future);
      return notifier;
    }

    test('그사이 새로고침이 끝났으면 늦은 페이지를 버린다(새 목록을 옛 목록으로 덮지 않음)', () async {
      final notifier = await loadFirstPage();
      final more = notifier.loadMore();
      final refresh = notifier.refreshList();
      notifier.gates[2].complete(_page(100));
      await refresh;
      notifier.gates[1].complete(_page(10));
      await more;
      expect(container.read(provider).value!.items, _page(100));
    });

    test('그사이 removeLocally 로 뺀 항목을 되살리지 않는다', () async {
      final notifier = await loadFirstPage();
      final more = notifier.loadMore();
      notifier.removeLocally((item) => item == 3);
      notifier.gates[1].complete(_page(10));
      await more;
      final items = container.read(provider).value!.items;
      expect(items, isNot(contains(3)));
      expect(items.length, 19);
    });

    test('새로고침 중에는 loadMore 를 보내지 않는다', () async {
      final notifier = await loadFirstPage();
      final refresh = notifier.refreshList();
      await notifier.loadMore();
      expect(notifier.gates.length, 2); // build 1 + 새로고침 1, loadMore 0
      notifier.gates[1].complete(_page(100));
      await refresh;
      expect(container.read(provider).value!.items, _page(100));
    });
  });
}
