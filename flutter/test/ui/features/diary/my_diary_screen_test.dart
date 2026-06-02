// MyDiaryScreen 위젯 스모크 — 헤더 + 빈 캘린더 렌더 (widget test, dio mock).
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:feeddiary/ui/core/theme/app_theme.dart';
import 'package:feeddiary/ui/features/diary/my_diary_screen.dart';
import 'package:feeddiary/utils/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  testWidgets('나의 일기 화면이 헤더와 함께 렌더되고 빈 날을 안내한다', (tester) async {
    final dio = buildDio(TokenStorage(const FlutterSecureStorage()));
    final adapter = DioAdapter(dio: dio);
    final now = DateTime.now();
    final key = monthKey(DateTime(now.year, now.month));
    adapter.onGet(
      '/diary/list-by-month/$key',
      (server) => server.reply(200, {'status': 'success', 'resData': <Map<String, dynamic>>[]}),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [dioProvider.overrideWithValue(dio)],
        child: MaterialApp(theme: buildAppTheme(), home: const MyDiaryScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('일기 쓰기'), findsOneWidget);
    expect(find.text('이 날의 일기가 없어요.'), findsOneWidget);
  });
}
