// LetterListNotifier — 무한 누적·끝 + isTodayLetterWritten/hasLetter 파생 + 작성 재조회(비낙관)·삭제 낙관·롤백 (Provider/Notifier test).
import 'package:dio/dio.dart';
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/ui/features/letter/letter_list_controller.dart';
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

  Map<String, dynamic> letterJson(int idx, {String? createdTime}) => {
    'idx': idx,
    'text': '편지 $idx',
    'created_time': createdTime ?? '2026-06-01T00:00:00.000Z',
  };

  setUp(() {
    dio = buildDio(TokenStorage(const FlutterSecureStorage()));
    adapter = DioAdapter(dio: dio);
  });

  test('첫 페이지 로드 후 loadMore 가 누적하고 끝을 감지한다', () async {
    adapter
      ..onGet(
        '/letter/list',
        (server) => server.reply(200, {'status': 'success', 'resData': List.generate(10, (i) => letterJson(i))}),
        queryParameters: {'skip': 0},
      )
      ..onGet(
        '/letter/list',
        (server) => server.reply(200, {'status': 'success', 'resData': List.generate(2, (i) => letterJson(100 + i))}),
        queryParameters: {'skip': 10},
      );

    final container = makeContainer();
    final first = await container.read(letterListProvider.future);
    expect(first.items.length, 10);
    expect(first.isEnd, false);

    await container.read(letterListProvider.notifier).loadMore();
    final after = container.read(letterListProvider).value!;
    expect(after.items.length, 12);
    expect(after.isEnd, true);
  });

  test('isTodayLetterWritten 는 최신 편지가 오늘이면 true', () async {
    final todayIso = DateTime.now().toIso8601String();
    adapter.onGet(
      '/letter/list',
      (server) => server.reply(200, {
        'status': 'success',
        'resData': [letterJson(1, createdTime: todayIso)],
      }),
      queryParameters: {'skip': 0},
    );
    final container = makeContainer();
    await container.read(letterListProvider.future);
    final notifier = container.read(letterListProvider.notifier);
    expect(notifier.hasLetter, true);
    expect(notifier.isTodayLetterWritten, true);
  });

  test('isTodayLetterWritten 는 과거 편지면 false', () async {
    adapter.onGet(
      '/letter/list',
      (server) => server.reply(200, {
        'status': 'success',
        'resData': [letterJson(1, createdTime: '2020-01-01T00:00:00.000Z')],
      }),
      queryParameters: {'skip': 0},
    );
    final container = makeContainer();
    await container.read(letterListProvider.future);
    final notifier = container.read(letterListProvider.notifier);
    expect(notifier.hasLetter, true);
    expect(notifier.isTodayLetterWritten, false);
  });

  test('빈 목록이면 hasLetter·isTodayLetterWritten 모두 false', () async {
    adapter.onGet(
      '/letter/list',
      (server) => server.reply(200, {'status': 'success', 'resData': <Map<String, dynamic>>[]}),
      queryParameters: {'skip': 0},
    );
    final container = makeContainer();
    await container.read(letterListProvider.future);
    final notifier = container.read(letterListProvider.notifier);
    expect(notifier.hasLetter, false);
    expect(notifier.isTodayLetterWritten, false);
  });

  test('작성은 비낙관이라 성공 후 서버 목록을 재조회한다', () async {
    adapter
      ..onGet(
        '/letter/list',
        (server) => server.reply(200, {
          'status': 'success',
          'resData': [letterJson(1)],
        }),
        queryParameters: {'skip': 0},
      )
      ..onPost(
        '/letter',
        (server) => server.reply(200, {'status': 'success', 'resData': letterJson(1)}),
        data: Matchers.any,
      );

    final container = makeContainer();
    await container.read(letterListProvider.future);
    await container.read(letterListProvider.notifier).create('내가 쓴 편지');

    final after = container.read(letterListProvider).value!;
    expect(after.items, hasLength(1));
    // 낙관 삽입이 아니라 서버 재조회라, 표시되는 건 입력값이 아니라 서버 편지(text='편지 1')다.
    expect(after.items.first.text, '편지 1');
    expect(after.items.first.text, isNot('내가 쓴 편지'));
  });

  test('삭제가 낙관적으로 제거한다', () async {
    adapter
      ..onGet(
        '/letter/list',
        (server) => server.reply(200, {
          'status': 'success',
          'resData': [letterJson(1), letterJson(2)],
        }),
        queryParameters: {'skip': 0},
      )
      ..onDelete('/letter/1', (server) => server.reply(200, {'status': 'success', 'resData': 'ok'}));

    final container = makeContainer();
    await container.read(letterListProvider.future);
    await container.read(letterListProvider.notifier).delete(1);

    final list = container.read(letterListProvider).value!.items;
    expect(list, hasLength(1));
    expect(list.map((l) => l.idx), isNot(contains(1)));
  });

  test('삭제 실패 시 이전 목록으로 롤백한다', () async {
    adapter
      ..onGet(
        '/letter/list',
        (server) => server.reply(200, {
          'status': 'success',
          'resData': [letterJson(1), letterJson(2)],
        }),
        queryParameters: {'skip': 0},
      )
      ..onDelete('/letter/1', (server) => server.reply(500, {'message': '실패'}));

    final container = makeContainer();
    await container.read(letterListProvider.future);
    await expectLater(container.read(letterListProvider.notifier).delete(1), throwsA(isA<AppException>()));

    final list = container.read(letterListProvider).value!.items;
    expect(list, hasLength(2));
    expect(list.map((l) => l.idx), contains(1));
  });
}
