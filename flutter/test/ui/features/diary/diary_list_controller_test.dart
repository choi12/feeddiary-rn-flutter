// DiaryListNotifier — 무한스크롤 첫 페이지·loadMore 누적·끝 감지 (Provider/Notifier test, http_mock_adapter).
import 'package:dio/dio.dart';
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:feeddiary/ui/features/diary/diary_list_controller.dart';
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

  Map<String, dynamic> diaryJson(int idx) => {
    'idx': idx,
    'user_idx': 1,
    'nickname': '새싹이',
    'sticker': 'Coffee',
    'text': '본문 $idx',
    'image': '',
    'created_time': '2026-06-01T00:00:00.000Z',
    'updated_time': null,
    'is_visible': 1,
    'like_count': 0,
    'commentCount': 0,
  };

  setUp(() {
    dio = buildDio(TokenStorage(const FlutterSecureStorage()));
    adapter = DioAdapter(dio: dio);
  });

  test('첫 페이지 로드 후 loadMore 가 누적하고 끝을 감지한다', () async {
    adapter
      ..onGet(
        '/diary/list',
        (server) => server.reply(200, {'status': 'success', 'resData': List.generate(10, (i) => diaryJson(i))}),
        queryParameters: {'skip': 0},
      )
      ..onGet(
        '/diary/list',
        (server) => server.reply(200, {'status': 'success', 'resData': List.generate(3, (i) => diaryJson(100 + i))}),
        queryParameters: {'skip': 10},
      );

    final container = makeContainer();
    final first = await container.read(diaryListProvider.future);
    expect(first.items.length, 10);
    expect(first.isEnd, false);

    await container.read(diaryListProvider.notifier).loadMore();
    final after = container.read(diaryListProvider).value!;
    expect(after.items.length, 13);
    expect(after.isEnd, true);
  });
}
