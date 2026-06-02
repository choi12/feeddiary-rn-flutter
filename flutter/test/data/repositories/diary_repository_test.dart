// DiaryRepository — 8 메서드 + operation 라벨 에러 (Provider/Notifier test, http_mock_adapter).
import 'package:dio/dio.dart';
import 'package:feeddiary/data/repositories/diary_repository.dart';
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

  DiaryRepository makeRepo() {
    final container = ProviderContainer(retry: (_, _) => null, overrides: [dioProvider.overrideWithValue(dio)]);
    addTearDown(container.dispose);
    return container.read(diaryRepositoryProvider);
  }

  Map<String, dynamic> diaryJson({int idx = 1, bool visible = true}) => {
    'idx': idx,
    'user_idx': 1,
    'nickname': '새싹이',
    'sticker': 'Coffee',
    'text': '본문',
    'image': '',
    'created_time': '2026-06-01T00:00:00.000Z',
    'updated_time': null,
    'is_visible': visible ? 1 : 0,
    'like_count': 0,
    'commentCount': 0,
    'user_image': '',
    'background': '',
    'character': 'Chick',
    'isLike': false,
  };

  setUp(() {
    dio = buildDio(TokenStorage(const FlutterSecureStorage()));
    adapter = DioAdapter(dio: dio);
  });

  test('getDiaries 가 목록을 파싱한다', () async {
    adapter.onGet(
      '/diary/list',
      (server) => server.reply(200, {
        'status': 'success',
        'resData': [diaryJson(idx: 1), diaryJson(idx: 2)],
      }),
      queryParameters: {'skip': 0},
    );
    final diaries = await makeRepo().getDiaries(skip: 0);
    expect(diaries.length, 2);
    expect(diaries.first.idx, 1);
  });

  test('getMonthlyDiaries 가 월별 목록을 파싱한다', () async {
    adapter.onGet(
      '/diary/list-by-month/2026-06',
      (server) => server.reply(200, {
        'status': 'success',
        'resData': [diaryJson()],
      }),
    );
    final list = await makeRepo().getMonthlyDiaries(month: '2026-06');
    expect(list.length, 1);
  });

  test('getDiary 가 CommunityDiary 를 파싱한다', () async {
    adapter.onGet('/diary/1', (server) => server.reply(200, {'status': 'success', 'resData': diaryJson(idx: 1)}));
    final diary = await makeRepo().getDiary(diaryIdx: 1);
    expect(diary.idx, 1);
    expect(diary.character, 'Chick');
  });

  test('createDiary 가 새 idx 를 반환한다', () async {
    adapter.onPost(
      '/diary',
      (server) => server.reply(200, {
        'status': 'success',
        'resData': {'diaryIdx': 99},
      }),
      data: Matchers.any,
    );
    final idx = await makeRepo().createDiary(sticker: 'Star', text: '새 일기', date: DateTime(2026, 6, 1));
    expect(idx, 99);
  });

  test('editDiary 가 idx 를 반환한다', () async {
    adapter.onPut(
      '/diary',
      (server) => server.reply(200, {
        'status': 'success',
        'resData': {'diaryIdx': 5},
      }),
      data: Matchers.any,
    );
    final idx = await makeRepo().editDiary(diaryIdx: 5, sticker: 'Star', text: '수정', date: DateTime(2026, 6, 1));
    expect(idx, 5);
  });

  test('deleteDiary 가 정상 완료된다', () async {
    adapter.onDelete('/diary/7', (server) => server.reply(200, {'status': 'success', 'resData': 'ok'}));
    await expectLater(makeRepo().deleteDiary(diaryIdx: 7), completes);
  });

  test('likeDiary 가 좋아요 결과를 반환한다', () async {
    adapter.onPost(
      '/diary/like',
      (server) => server.reply(200, {
        'status': 'success',
        'resData': {'like_count': 4, 'isLike': true},
      }),
      data: Matchers.any,
    );
    final result = await makeRepo().likeDiary(diaryIdx: 1);
    expect(result.likeCount, 4);
    expect(result.isLike, true);
  });

  test('setVisibility 가 공개 여부를 반환한다', () async {
    adapter.onPost(
      '/diary/visibility',
      (server) => server.reply(200, {
        'status': 'success',
        'resData': {'is_visible': 0},
      }),
      data: Matchers.any,
    );
    final visible = await makeRepo().setVisibility(diaryIdx: 1);
    expect(visible, false);
  });

  test('서버 에러는 operation 라벨이 붙은 ApiException', () async {
    adapter.onGet('/diary/list', (server) => server.reply(500, {'message': '서버 오류'}), queryParameters: {'skip': 0});
    await expectLater(
      makeRepo().getDiaries(skip: 0),
      throwsA(isA<ApiException>().having((e) => e.displayMessage, 'displayMessage', startsWith('[나의 일기 리스트]'))),
    );
  });
}
