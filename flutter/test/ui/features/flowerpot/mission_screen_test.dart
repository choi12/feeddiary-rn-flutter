// MissionScreen 위젯 스모크 — 진행중/완료 탭 + 미션 카드 렌더 (widget test, dio mock).
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:feeddiary/ui/core/theme/app_theme.dart';
import 'package:feeddiary/ui/features/flowerpot/mission_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  testWidgets('미션 화면이 탭과 미션 카드를 렌더한다', (tester) async {
    final dio = buildDio(TokenStorage(const FlutterSecureStorage()));
    final adapter = DioAdapter(dio: dio);
    adapter.onGet(
      '/mission/list',
      (server) => server.reply(200, {
        'status': 'success',
        'resData': {
          'completed': <dynamic>[],
          'inProgress': [
            {'idx': 1, 'type': 'diary', 'count': 1, 'max_count': 3, 'is_completed': 0},
            {'idx': 3, 'type': 'visible', 'count': 1, 'max_count': 1, 'is_completed': 0},
          ],
        },
      }),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [dioProvider.overrideWithValue(dio)],
        child: MaterialApp(theme: buildAppTheme(), home: const MissionScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('오늘의 미션'), findsOneWidget);
    // 미션 제목은 제목+[진행도]를 한 Text.rich 로 합쳐 그리므로 textContaining 으로 찾는다.
    expect(find.textContaining('일기 쓰기'), findsOneWidget);
    expect(find.textContaining('일기 공개하기'), findsOneWidget);
    expect(find.text('보상 받기'), findsWidgets);
  });
}
