// CommentsController — 작성 후 재조회·삭제 낙관 제거·삭제 실패 롤백 (Provider/Notifier test, http_mock_adapter).
import 'package:dio/dio.dart';
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/ui/features/community/comments_controller.dart';
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

  Map<String, dynamic> commentJson(int idx) => {
    'idx': idx,
    'nickname': '구름이',
    'background': '',
    'character': 'Cat',
    'text': '댓글 $idx',
    'created_time': '2026-06-01T00:00:00.000Z',
    'user_image': '',
  };

  setUp(() {
    dio = buildDio(TokenStorage(const FlutterSecureStorage()));
    adapter = DioAdapter(dio: dio);
  });

  test('작성이 성공하면 서버 목록을 재조회한다(비낙관)', () async {
    adapter
      ..onGet(
        '/comment/list/5',
        (server) => server.reply(200, {
          'status': 'success',
          'resData': [commentJson(1)],
        }),
      )
      ..onPost('/comment', (server) => server.reply(200, {'status': 'success', 'resData': '1'}), data: Matchers.any);

    final container = makeContainer();
    await container.read(commentsControllerProvider(5).future);
    await container.read(commentsControllerProvider(5).notifier).create('내가 쓴 댓글');

    final after = container.read(commentsControllerProvider(5)).value!;
    expect(after, hasLength(1));
    // 낙관 삽입이 아니라 서버 재조회라, 표시되는 건 입력값이 아니라 서버 댓글(text='댓글 1')이다.
    expect(after.first.text, '댓글 1');
    expect(after.first.text, isNot('내가 쓴 댓글'));
  });

  test('삭제가 낙관적으로 제거한다', () async {
    adapter
      ..onGet(
        '/comment/list/5',
        (server) => server.reply(200, {
          'status': 'success',
          'resData': [commentJson(1), commentJson(2)],
        }),
      )
      ..onDelete('/comment/1', (server) => server.reply(200, {'status': 'success', 'resData': 'ok'}));

    final container = makeContainer();
    await container.read(commentsControllerProvider(5).future);
    await container.read(commentsControllerProvider(5).notifier).delete(1);

    final list = container.read(commentsControllerProvider(5)).value!;
    expect(list, hasLength(1));
    expect(list.map((c) => c.idx), isNot(contains(1)));
  });

  test('삭제 실패 시 이전 목록으로 롤백한다', () async {
    adapter
      ..onGet(
        '/comment/list/5',
        (server) => server.reply(200, {
          'status': 'success',
          'resData': [commentJson(1), commentJson(2)],
        }),
      )
      ..onDelete('/comment/1', (server) => server.reply(500, {'message': '실패'}));

    final container = makeContainer();
    await container.read(commentsControllerProvider(5).future);
    await expectLater(container.read(commentsControllerProvider(5).notifier).delete(1), throwsA(isA<AppException>()));

    final list = container.read(commentsControllerProvider(5)).value!;
    expect(list, hasLength(2));
    expect(list.map((c) => c.idx), contains(1));
  });
}
