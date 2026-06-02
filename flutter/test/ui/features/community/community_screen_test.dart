// CommunityScreen 위젯 스모크 — 정렬 토글 + 공유 카드 렌더 (widget test, dio mock).
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:feeddiary/ui/core/theme/app_theme.dart';
import 'package:feeddiary/ui/features/community/community_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  testWidgets('공유 일기 화면이 정렬 토글과 카드를 렌더한다', (tester) async {
    final dio = buildDio(TokenStorage(const FlutterSecureStorage()));
    final adapter = DioAdapter(dio: dio);
    adapter.onGet(
      '/diary/community-list',
      (server) => server.reply(200, {
        'status': 'success',
        'resData': [
          {
            'idx': 1,
            'user_idx': 2,
            'nickname': '햇살이',
            'sticker': 'Sunny',
            'text': '공유 일기 본문입니다.',
            'image': '',
            'created_time': '2026-06-01T00:00:00.000Z',
            'updated_time': null,
            'is_visible': 1,
            'like_count': 3,
            'commentCount': 1,
            'user_image': '',
            'background': '',
            'character': 'Bear',
            'isLike': false,
          },
        ],
      }),
      queryParameters: {'skip': 0, 'sort_type': 'latest'},
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [dioProvider.overrideWithValue(dio)],
        child: MaterialApp(theme: buildAppTheme(), home: const CommunityScreen()),
      ),
    );
    await tester.pumpAndSettle();

    // 정렬 드롭다운은 현재 정렬 라벨만 보인다(나머지는 시트를 열어야 — RN SortButton).
    expect(find.text('최신글'), findsOneWidget);
    expect(find.text('공유 일기 본문입니다.'), findsOneWidget);
    expect(find.text('햇살이'), findsOneWidget);
  });
}
