// DiaryLikes — 좋아요 낙관 flip·서버 보정·실패 revert + 글로벌 동기화(목록↔상세 일관) (Provider/Notifier test, http_mock_adapter).
import 'package:dio/dio.dart';
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/ui/features/community/diary_likes.dart';
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

  setUp(() {
    dio = buildDio(TokenStorage(const FlutterSecureStorage()));
    adapter = DioAdapter(dio: dio);
  });

  test('toggle 가 낙관 flip 후 서버 결과로 보정한다', () async {
    adapter.onPost(
      '/diary/like',
      (server) => server.reply(200, {
        'status': 'success',
        'resData': {'like_count': 6, 'isLike': true},
      }),
      data: Matchers.any,
    );

    final container = makeContainer();
    await container.read(diaryLikesProvider.notifier).toggle(idx: 1, baseIsLike: false, baseLikeCount: 5);
    final like = container.read(diaryLikesProvider)[1]!;
    expect(like.isLike, true);
    expect(like.likeCount, 6);
  });

  test('toggle 실패 시 base 로 되돌린다', () async {
    adapter.onPost('/diary/like', (server) => server.reply(500, {'message': '실패'}), data: Matchers.any);

    final container = makeContainer();
    await expectLater(
      container.read(diaryLikesProvider.notifier).toggle(idx: 1, baseIsLike: false, baseLikeCount: 5),
      throwsA(isA<AppException>()),
    );
    final like = container.read(diaryLikesProvider)[1]!;
    expect(like.isLike, false);
    expect(like.likeCount, 5);
  });

  test('토글 후 목록·상세가 base 가 달라도 같은 override 를 본다(글로벌 동기화)', () async {
    adapter.onPost(
      '/diary/like',
      (server) => server.reply(200, {
        'status': 'success',
        'resData': {'like_count': 4, 'isLike': true},
      }),
      data: Matchers.any,
    );

    final container = makeContainer();
    // 위젯이 override 없으면 자기 base 로, 있으면 override 로 표시한다.
    LikeState effective(LikeState base) => container.read(diaryLikesProvider)[9] ?? base;

    // 토글 전: override 없음 → 각 화면이 자기 base 를 본다.
    expect(container.read(diaryLikesProvider)[9], isNull);

    await container.read(diaryLikesProvider.notifier).toggle(idx: 9, baseIsLike: false, baseLikeCount: 3);

    // 토글 후: base 가 달라도 단일 override 로 수렴한다.
    final listView = effective((isLike: false, likeCount: 3));
    final detailView = effective((isLike: false, likeCount: 99));
    expect(listView, detailView);
    expect(listView.isLike, true);
    expect(listView.likeCount, 4);
  });

  group('요청 중 가드(토글 API 라 연타로 요청이 둘 나가면 서버가 두 번 뒤집힌다)', () {
    late int calls;

    setUp(() {
      calls = 0;
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path.endsWith('/diary/like')) calls++;
            handler.next(options);
          },
        ),
      );
    });

    void replyLiked({Duration? delay}) => adapter.onPost(
      '/diary/like',
      (server) => server.reply(200, {
        'status': 'success',
        'resData': {'like_count': 6, 'isLike': true},
      }, delay: delay),
      data: Matchers.any,
    );

    test('같은 일기의 요청이 떠 있는 동안 다시 누르면 요청을 보내지 않고 false 를 돌려준다', () async {
      replyLiked(delay: const Duration(milliseconds: 50));
      final container = makeContainer();
      final notifier = container.read(diaryLikesProvider.notifier);

      final first = notifier.toggle(idx: 1, baseIsLike: false, baseLikeCount: 5);
      final second = await notifier.toggle(idx: 1, baseIsLike: false, baseLikeCount: 5);

      expect(second, isFalse);
      expect(container.read(diaryLikesProvider)[1], (isLike: true, likeCount: 6)); // 낙관값 그대로(되뒤집히지 않음)
      expect(await first, isTrue);
      expect(calls, 1);
      expect(container.read(diaryLikesProvider)[1], (isLike: true, likeCount: 6));
    });

    test('다른 일기는 막지 않고, 응답이 끝나면 같은 일기도 다시 누를 수 있다', () async {
      replyLiked(delay: const Duration(milliseconds: 50));
      final container = makeContainer();
      final notifier = container.read(diaryLikesProvider.notifier);

      final first = notifier.toggle(idx: 1, baseIsLike: false, baseLikeCount: 5);
      expect(await notifier.toggle(idx: 2, baseIsLike: false, baseLikeCount: 0), isTrue);
      await first;
      expect(await notifier.toggle(idx: 1, baseIsLike: true, baseLikeCount: 6), isTrue);
      expect(calls, 3);
    });

    test('실패해도 가드가 풀려 다시 누를 수 있다', () async {
      adapter.onPost('/diary/like', (server) => server.reply(500, {'message': '실패'}), data: Matchers.any);
      final container = makeContainer();
      final notifier = container.read(diaryLikesProvider.notifier);

      await expectLater(notifier.toggle(idx: 1, baseIsLike: false, baseLikeCount: 5), throwsA(isA<AppException>()));
      await expectLater(notifier.toggle(idx: 1, baseIsLike: false, baseLikeCount: 5), throwsA(isA<AppException>()));
      expect(calls, 2);
    });
  });
}
