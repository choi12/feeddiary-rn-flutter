// CommunityRepository — 목록/댓글 CRUD/신고 + operation 라벨 에러 (repository test, http_mock_adapter).
import 'package:dio/dio.dart';
import 'package:feeddiary/data/models/community_diary.dart';
import 'package:feeddiary/data/repositories/community_repository.dart';
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/domain/models/community_sort.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;

  CommunityRepository makeRepo() {
    final container = ProviderContainer(retry: (_, _) => null, overrides: [dioProvider.overrideWithValue(dio)]);
    addTearDown(container.dispose);
    return container.read(communityRepositoryProvider);
  }

  Map<String, dynamic> communityJson(int idx, {int likeCount = 0}) => {
    'idx': idx,
    'user_idx': 2,
    'nickname': '햇살이',
    'sticker': 'Sunny',
    'text': '본문 $idx',
    'image': '',
    'created_time': '2026-06-01T00:00:00.000Z',
    'updated_time': null,
    'is_visible': 1,
    'like_count': likeCount,
    'commentCount': 0,
    'user_image': '',
    'background': '',
    'character': 'Bear',
    'isLike': false,
  };

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

  test('getCommunityDiaries 가 skip/sort_type 쿼리로 목록을 파싱한다', () async {
    adapter.onGet(
      '/diary/community-list',
      (server) => server.reply(200, {
        'status': 'success',
        'resData': [communityJson(1, likeCount: 5), communityJson(2)],
      }),
      queryParameters: {'skip': 0, 'sort_type': 'popular'},
    );
    final list = await makeRepo().getCommunityDiaries(skip: 0, sort: CommunitySort.popular);
    expect(list, hasLength(2));
    expect(list.first, isA<CommunityDiary>());
    expect(list.first.nickname, '햇살이');
  });

  test('getComments 가 댓글 목록을 파싱한다', () async {
    adapter.onGet(
      '/comment/list/5',
      (server) => server.reply(200, {
        'status': 'success',
        'resData': [commentJson(1)],
      }),
    );
    final comments = await makeRepo().getComments(diaryIdx: 5);
    expect(comments, hasLength(1));
    expect(comments.first.text, '댓글 1');
  });

  test('createComment 가 정상 완료된다', () async {
    adapter.onPost(
      '/comment',
      (server) => server.reply(200, {'status': 'success', 'resData': '99'}),
      data: Matchers.any,
    );
    await expectLater(makeRepo().createComment(diaryIdx: 5, text: '새 댓글'), completes);
  });

  test('deleteComment 가 정상 완료된다', () async {
    adapter.onDelete('/comment/9', (server) => server.reply(200, {'status': 'success', 'resData': 'ok'}));
    await expectLater(makeRepo().deleteComment(commentIdx: 9), completes);
  });

  test('reportDiary 가 정상 완료된다', () async {
    adapter.onPost(
      '/diary/report',
      (server) => server.reply(200, {'status': 'success', 'resData': 'ok'}),
      data: Matchers.any,
    );
    await expectLater(makeRepo().reportDiary(diaryIdx: 5, text: '부적절', blockIdx: 1), completes);
  });

  test('서버 에러는 operation 라벨이 붙은 ApiException', () async {
    adapter.onGet('/comment/list/5', (server) => server.reply(500, {'message': '서버 오류'}));
    await expectLater(
      makeRepo().getComments(diaryIdx: 5),
      throwsA(isA<ApiException>().having((e) => e.displayMessage, 'displayMessage', startsWith('[댓글 리스트]'))),
    );
  });
}
