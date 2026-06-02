// CommentsScreen 위젯 스모크 — 댓글 목록 + 입력창 렌더 (widget test, dio mock).
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/app_theme.dart';
import 'package:feeddiary/ui/features/community/comments_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  testWidgets('댓글 화면이 목록과 입력창을 렌더한다', (tester) async {
    final dio = buildDio(TokenStorage(const FlutterSecureStorage()));
    final adapter = DioAdapter(dio: dio);
    adapter.onGet(
      '/comment/list/5',
      (server) => server.reply(200, {
        'status': 'success',
        'resData': [
          {
            'idx': 1,
            'nickname': '구름이',
            'background': '',
            'character': 'Cat',
            'text': '좋은 글이에요.',
            'created_time': '2026-06-01T00:00:00.000Z',
            'user_image': '',
          },
        ],
      }),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [dioProvider.overrideWithValue(dio)],
        child: MaterialApp(
          theme: buildAppTheme(),
          home: const CommentsScreen(diaryIdx: 5, author: '햇살이'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('좋은 글이에요.'), findsOneWidget);
    expect(find.text('구름이'), findsOneWidget);
    expect(find.byIcon(FeedIcons.send), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });
}
