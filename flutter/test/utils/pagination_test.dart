// OffsetPagination 믹스인 — 페이지 누적·끝 감지·loadMore 가드 (Provider/Notifier test, fake fetchPage).
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
}
