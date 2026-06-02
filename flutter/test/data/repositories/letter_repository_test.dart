// LetterRepository — 목록/작성/삭제 + operation 라벨 에러 (repository test, http_mock_adapter).
import 'package:dio/dio.dart';
import 'package:feeddiary/data/models/letter.dart';
import 'package:feeddiary/data/repositories/letter_repository.dart';
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;

  LetterRepository makeRepo() {
    final container = ProviderContainer(retry: (_, _) => null, overrides: [dioProvider.overrideWithValue(dio)]);
    addTearDown(container.dispose);
    return container.read(letterRepositoryProvider);
  }

  Map<String, dynamic> letterJson(int idx) => {
    'idx': idx,
    'text': '편지 $idx',
    'created_time': '2026-06-01T00:00:00.000Z',
  };

  setUp(() {
    dio = buildDio(TokenStorage(const FlutterSecureStorage()));
    adapter = DioAdapter(dio: dio);
  });

  test('getLetters 가 skip 쿼리로 목록을 파싱한다', () async {
    adapter.onGet(
      '/letter/list',
      (server) => server.reply(200, {
        'status': 'success',
        'resData': [letterJson(1), letterJson(2)],
      }),
      queryParameters: {'skip': 0},
    );
    final list = await makeRepo().getLetters(skip: 0);
    expect(list, hasLength(2));
    expect(list.first, isA<Letter>());
    expect(list.first.text, '편지 1');
  });

  test('createLetter 가 정상 완료된다', () async {
    adapter.onPost(
      '/letter',
      (server) => server.reply(200, {'status': 'success', 'resData': letterJson(99)}),
      data: Matchers.any,
    );
    await expectLater(makeRepo().createLetter(text: '새 편지'), completes);
  });

  test('deleteLetter 가 정상 완료된다', () async {
    adapter.onDelete('/letter/9', (server) => server.reply(200, {'status': 'success', 'resData': 'ok'}));
    await expectLater(makeRepo().deleteLetter(letterIdx: 9), completes);
  });

  test('서버 에러는 operation 라벨이 붙은 ApiException', () async {
    adapter.onGet('/letter/list', (server) => server.reply(500, {'message': '서버 오류'}), queryParameters: {'skip': 0});
    await expectLater(
      makeRepo().getLetters(skip: 0),
      throwsA(isA<ApiException>().having((e) => e.displayMessage, 'displayMessage', startsWith('[나의 편지 리스트]'))),
    );
  });
}
