// CommunityListNotifier — 무한스크롤 첫 페이지·loadMore·끝 + 정렬 변경 재조회 (Provider/Notifier test, http_mock_adapter).
import 'package:dio/dio.dart';
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:feeddiary/domain/models/community_sort.dart';
import 'package:feeddiary/ui/features/community/community_list_controller.dart';
import 'package:feeddiary/ui/features/community/community_sort_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;

  ProviderContainer makeContainer() {
    final container = ProviderContainer(retry: (_, _) => null, overrides: [dioProvider.overrideWithValue(dio)]);
    addTearDown(container.dispose);
    return container;
  }

  Map<String, dynamic> communityJson(int idx) => {
    'idx': idx,
    'user_idx': 2,
    'nickname': '햇살이',
    'sticker': 'Sunny',
    'text': '본문 $idx',
    'image': '',
    'created_time': '2026-06-01T00:00:00.000Z',
    'updated_time': null,
    'is_visible': 1,
    'like_count': 0,
    'commentCount': 0,
    'user_image': '',
    'background': '',
    'character': 'Bear',
    'isLike': false,
  };

  setUp(() {
    dio = buildDio(TokenStorage(const FlutterSecureStorage()));
    adapter = DioAdapter(dio: dio);
  });

  test('첫 페이지 로드 후 loadMore 가 누적하고 끝을 감지한다', () async {
    adapter
      ..onGet(
        '/diary/community-list',
        (server) => server.reply(200, {'status': 'success', 'resData': List.generate(10, (i) => communityJson(i))}),
        queryParameters: {'skip': 0, 'sort_type': 'latest'},
      )
      ..onGet(
        '/diary/community-list',
        (server) =>
            server.reply(200, {'status': 'success', 'resData': List.generate(2, (i) => communityJson(100 + i))}),
        queryParameters: {'skip': 10, 'sort_type': 'latest'},
      );

    final container = makeContainer();
    final first = await container.read(communityListProvider.future);
    expect(first.items.length, 10);
    expect(first.isEnd, false);

    await container.read(communityListProvider.notifier).loadMore();
    final after = container.read(communityListProvider).value!;
    expect(after.items.length, 12);
    expect(after.isEnd, true);
  });

  test('정렬을 인기로 바꾸면 새 sort_type 으로 재조회한다', () async {
    adapter
      ..onGet(
        '/diary/community-list',
        (server) => server.reply(200, {
          'status': 'success',
          'resData': [communityJson(1)],
        }),
        queryParameters: {'skip': 0, 'sort_type': 'latest'},
      )
      ..onGet(
        '/diary/community-list',
        (server) => server.reply(200, {
          'status': 'success',
          'resData': [communityJson(2), communityJson(3)],
        }),
        queryParameters: {'skip': 0, 'sort_type': 'popular'},
      );

    final container = makeContainer();
    final latest = await container.read(communityListProvider.future);
    expect(latest.items.length, 1);

    container.read(communitySortControllerProvider.notifier).set(CommunitySort.popular);
    await Future<void>.delayed(Duration.zero);
    final popular = await container.read(communityListProvider.future);
    expect(popular.items.length, 2);
  });
}
