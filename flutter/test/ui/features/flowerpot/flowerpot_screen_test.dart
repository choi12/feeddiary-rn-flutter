// FlowerpotScreen 위젯 스모크 — 레벨/경험치 + 물/사랑 버튼 렌더 (widget test, dio mock).
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:feeddiary/ui/core/theme/app_theme.dart';
import 'package:feeddiary/ui/features/flowerpot/flowerpot_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  testWidgets('화분 화면이 레벨·경험치·물/사랑 버튼을 렌더한다', (tester) async {
    final dio = buildDio(TokenStorage(const FlutterSecureStorage()));
    final adapter = DioAdapter(dio: dio);
    adapter.onGet(
      '/flowerpot',
      (server) => server.reply(200, {
        'status': 'success',
        'resData': {'level': 2, 'exp': 400, 'max_exp': 1000, 'watering_count': 2, 'love_count': 1, 'showBadge': false},
      }),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [dioProvider.overrideWithValue(dio)],
        child: MaterialApp(theme: buildAppTheme(), home: const FlowerpotScreen()),
      ),
    );
    // 배경 새/풍선 Lottie 가 무한 애니메이션이라 pumpAndSettle 대신 pump 로 비동기 로드만 처리한다.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Lv.2'), findsOneWidget);
    expect(find.text('물 주기'), findsOneWidget);
    expect(find.text('사랑 주기'), findsOneWidget);
  });
}
