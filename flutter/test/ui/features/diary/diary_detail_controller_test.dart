// DiaryDetailController — 공개여부 낙관 토글 (Provider/Notifier test, http_mock_adapter). 좋아요는 diary_likes_test.
import 'package:dio/dio.dart';
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:feeddiary/ui/features/diary/diary_detail_controller.dart';
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

  Map<String, dynamic> diaryJson({bool isLike = false, int likeCount = 2, bool visible = true}) => {
    'idx': 1,
    'user_idx': 1,
    'nickname': '새싹이',
    'sticker': 'Coffee',
    'text': '본문',
    'image': '',
    'created_time': '2026-06-01T00:00:00.000Z',
    'updated_time': null,
    'is_visible': visible ? 1 : 0,
    'like_count': likeCount,
    'commentCount': 0,
    'user_image': '',
    'background': '',
    'character': 'Chick',
    'isLike': isLike,
  };

  setUp(() {
    dio = buildDio(TokenStorage(const FlutterSecureStorage()));
    adapter = DioAdapter(dio: dio);
  });

  test('toggleVisibility 가 공개 여부를 토글한다', () async {
    adapter
      ..onGet('/diary/1', (server) => server.reply(200, {'status': 'success', 'resData': diaryJson(visible: true)}))
      ..onPost(
        '/diary/visibility',
        (server) => server.reply(200, {
          'status': 'success',
          'resData': {'is_visible': 0},
        }),
        data: Matchers.any,
      );

    final container = makeContainer();
    await container.read(diaryDetailControllerProvider(1).future);
    await container.read(diaryDetailControllerProvider(1).notifier).toggleVisibility();
    expect(container.read(diaryDetailControllerProvider(1)).value!.isVisible, false);
  });
}
