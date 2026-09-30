// 일기 교차 무효화 — 작성·수정·삭제가 목록을 다시 불러오게 하고, 공개 전환·삭제는 로드된 목록을 먼저 고치는지. RN DIARIES_GROUP.
import 'package:feeddiary/config/api_config.dart';
import 'package:feeddiary/data/services/demo_api_adapter.dart';
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:feeddiary/ui/features/community/community_list_controller.dart';
import 'package:feeddiary/ui/features/diary/create_diary_controller.dart';
import 'package:feeddiary/ui/features/diary/diary_detail_controller.dart';
import 'package:feeddiary/ui/features/diary/diary_list_controller.dart';
import 'package:feeddiary/ui/features/diary/monthly_diaries_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ProviderContainer makeContainer() {
    final dio = buildDio(TokenStorage(const FlutterSecureStorage()))
      ..httpClientAdapter = DemoApiAdapter(latency: Duration.zero);
    final container = ProviderContainer(retry: (_, _) => null, overrides: [dioProvider.overrideWithValue(dio)]);
    addTearDown(container.dispose);
    return container;
  }

  test('공개 전환한 내 일기가 공유 목록에 나타나고, 삭제하면 사라진다', () async {
    final dio = buildDio(TokenStorage(const FlutterSecureStorage()))
      ..httpClientAdapter = DemoApiAdapter(latency: Duration.zero);
    final container = ProviderContainer(retry: (_, _) => null, overrides: [dioProvider.overrideWithValue(dio)]);
    addTearDown(container.dispose);
    container.listen(communityListProvider, (_, _) {});
    container.listen(createDiaryControllerProvider(null), (_, _) {});

    Future<List<int>> communityIdxs() async =>
        (await container.read(communityListProvider.future)).items.map((d) => d.idx).toList();

    await communityIdxs();
    container.read(createDiaryControllerProvider(null).notifier)
      ..setSticker('Star')
      ..setText('공개할 일기');
    final idx = await container.read(createDiaryControllerProvider(null).notifier).submit();
    await container.read(diaryDetailControllerProvider(idx).future);
    final detail = container.read(diaryDetailControllerProvider(idx).notifier);

    await detail.toggleVisibility();
    expect(await communityIdxs(), contains(idx));

    await detail.delete();
    expect(await communityIdxs(), isNot(contains(idx)));
  });

  ProviderContainer makeSlowContainer() {
    final dio = buildDio(TokenStorage(const FlutterSecureStorage()))
      ..httpClientAdapter = DemoApiAdapter(latency: const Duration(milliseconds: 50));
    final container = ProviderContainer(retry: (_, _) => null, overrides: [dioProvider.overrideWithValue(dio)]);
    addTearDown(container.dispose);
    return container;
  }

  test('상세에서 공개 여부를 바꾸면 재조회 없이 내 일기 목록·월별 캐시의 그 항목만 바뀐다', () async {
    final container = makeSlowContainer();
    container.listen(diaryListProvider, (_, _) {});
    container.listen(monthlyDiariesProvider('2026-05'), (_, _) {});
    container.listen(diaryDetailControllerProvider(1001), (_, _) {});

    final before = (await container.read(diaryListProvider.future)).items.firstWhere((d) => d.idx == 1001).isVisible;
    final monthly = await container.read(monthlyDiariesProvider('2026-05').future);
    expect(monthly.firstWhere((d) => d.idx == 1001).isVisible, before);
    await container.read(diaryDetailControllerProvider(1001).future);
    await container.read(diaryDetailControllerProvider(1001).notifier).toggleVisibility();

    // 재조회(무효화) 없이 바로 반영 — 둘 다 로딩 상태로 떨어지지 않는다.
    final list = container.read(diaryListProvider);
    final month = container.read(monthlyDiariesProvider('2026-05'));
    expect(list.isLoading, isFalse);
    expect(month.isLoading, isFalse);
    expect(list.value!.items.firstWhere((d) => d.idx == 1001).isVisible, !before);
    expect(month.value!.firstWhere((d) => d.idx == 1001).isVisible, !before);
    expect(month.value!.length, monthly.length);
  });

  test('공개 여부를 바꿔도 내 일기 목록의 더 불러온 페이지가 유지된다', () async {
    final container = makeSlowContainer();
    container.listen(diaryListProvider, (_, _) {});
    container.listen(diaryDetailControllerProvider(1012), (_, _) {});

    await container.read(diaryListProvider.future);
    await container.read(diaryListProvider.notifier).loadMore();
    final loaded = container.read(diaryListProvider).value!.items;
    expect(loaded.length, greaterThan(ApiConfig.itemsPerPage)); // 2페이지 로드됨
    final before = loaded.firstWhere((d) => d.idx == 1012).isVisible;

    await container.read(diaryDetailControllerProvider(1012).future);
    await container.read(diaryDetailControllerProvider(1012).notifier).toggleVisibility();

    final after = (await container.read(diaryListProvider.future)).items;
    expect(after.length, loaded.length);
    expect(after.firstWhere((d) => d.idx == 1012).isVisible, !before);
  });

  test('공유 목록에서 연 내 공개 일기를 비공개로 바꾸면 더 불러온 페이지를 유지한 채 그 일기만 빠진다', () async {
    final container = makeSlowContainer();
    container.listen(communityListProvider, (_, _) {});
    container.listen(diaryDetailControllerProvider(1002), (_, _) {});

    await container.read(communityListProvider.future);
    await container.read(communityListProvider.notifier).loadMore();
    final loaded = container.read(communityListProvider).value!.items;
    expect(loaded.length, greaterThan(ApiConfig.itemsPerPage)); // 2페이지 로드됨
    expect(loaded.map((d) => d.idx), contains(1002)); // 시드 1002 는 공개

    await container.read(diaryDetailControllerProvider(1002).future);
    await container.read(diaryDetailControllerProvider(1002).notifier).toggleVisibility();

    final community = container.read(communityListProvider);
    expect(community.isLoading, isFalse);
    expect(community.value!.items.length, loaded.length - 1);
    expect(community.value!.items.map((d) => d.idx), isNot(contains(1002)));
  });

  test('캘린더가 연 달의 일기를 삭제하면 재조회를 기다리지 않고 월별 목록에서 바로 빠진다', () async {
    final container = makeSlowContainer();
    container.listen(monthlyDiariesProvider('2026-05'), (_, _) {});
    container.listen(diaryDetailControllerProvider(1001), (_, _) {});

    expect((await container.read(monthlyDiariesProvider('2026-05').future)).map((d) => d.idx), contains(1001));
    await container.read(diaryDetailControllerProvider(1001).future);
    await container.read(diaryDetailControllerProvider(1001).notifier).delete();

    // 삭제 직후(재조회 응답 전) — 캘린더 화면으로 돌아오는 시점.
    final month = container.read(monthlyDiariesProvider('2026-05'));
    expect(month.isLoading, isTrue);
    expect(month.value!.map((d) => d.idx), isNot(contains(1001)));
    expect((await container.read(monthlyDiariesProvider('2026-05').future)).map((d) => d.idx), isNot(contains(1001)));
  });

  test('공개된 내 일기 본문을 수정하면 공유 목록에 새 본문이 보인다', () async {
    final container = makeContainer();
    container.listen(communityListProvider, (_, _) {});
    container.listen(createDiaryControllerProvider(null), (_, _) {});

    Future<String?> communityText(int idx) async =>
        (await container.read(communityListProvider.future)).items.where((d) => d.idx == idx).firstOrNull?.text;

    container.read(createDiaryControllerProvider(null).notifier)
      ..setSticker('Star')
      ..setText('수정 전');
    final idx = await container.read(createDiaryControllerProvider(null).notifier).submit();
    await container.read(diaryDetailControllerProvider(idx).future);
    await container.read(diaryDetailControllerProvider(idx).notifier).toggleVisibility();
    expect(await communityText(idx), '수정 전');

    final initial = (await container.read(diaryListProvider.future)).items.firstWhere((d) => d.idx == idx);
    container.listen(createDiaryControllerProvider(initial), (_, _) {});
    container.read(createDiaryControllerProvider(initial).notifier).setText('수정 후');
    await container.read(createDiaryControllerProvider(initial).notifier).submit();

    expect(await communityText(idx), '수정 후');
  });

  test('내 공개 일기를 삭제하면 재조회를 기다리지 않고 공유·내 일기 목록에서 바로 빠지고, 재조회 뒤에도 없다', () async {
    final dio = buildDio(TokenStorage(const FlutterSecureStorage()))
      ..httpClientAdapter = DemoApiAdapter(latency: const Duration(milliseconds: 50));
    final container = ProviderContainer(retry: (_, _) => null, overrides: [dioProvider.overrideWithValue(dio)]);
    addTearDown(container.dispose);
    container.listen(communityListProvider, (_, _) {});
    container.listen(diaryListProvider, (_, _) {});
    container.listen(createDiaryControllerProvider(null), (_, _) {});

    container.read(createDiaryControllerProvider(null).notifier)
      ..setSticker('Star')
      ..setText('지울 공개 일기');
    final idx = await container.read(createDiaryControllerProvider(null).notifier).submit();
    await container.read(diaryDetailControllerProvider(idx).future);
    await container.read(diaryDetailControllerProvider(idx).notifier).toggleVisibility();
    expect((await container.read(communityListProvider.future)).items.map((d) => d.idx), contains(idx));
    expect((await container.read(diaryListProvider.future)).items.map((d) => d.idx), contains(idx));

    await container.read(diaryDetailControllerProvider(idx).notifier).delete();

    // 삭제 직후(재조회 응답 전) — 화면이 pop 되어 목록으로 돌아오는 시점.
    final community = container.read(communityListProvider);
    final mine = container.read(diaryListProvider);
    expect(community.isLoading, isTrue);
    expect(community.value!.items.map((d) => d.idx), isNot(contains(idx)));
    expect(mine.value!.items.map((d) => d.idx), isNot(contains(idx)));

    expect((await container.read(communityListProvider.future)).items.map((d) => d.idx), isNot(contains(idx)));
    expect((await container.read(diaryListProvider.future)).items.map((d) => d.idx), isNot(contains(idx)));
  });
}
