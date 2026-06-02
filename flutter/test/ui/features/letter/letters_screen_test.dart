// LettersScreen 위젯 스모크 — 편지함 헤더·작성 버튼·편지 카드 렌더 (widget test, dio mock).
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:feeddiary/ui/core/theme/app_theme.dart';
import 'package:feeddiary/ui/features/letter/letter_strings.dart';
import 'package:feeddiary/ui/features/letter/letters_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  testWidgets('편지함이 헤더·작성 버튼·편지 카드를 렌더한다', (tester) async {
    final dio = buildDio(TokenStorage(const FlutterSecureStorage()));
    final adapter = DioAdapter(dio: dio);
    adapter.onGet(
      '/letter/list',
      (server) => server.reply(200, {
        'status': 'success',
        // 과거 날짜라 isTodayLetterWritten=false → 작성 버튼이 활성 라벨로 보인다(결정적).
        'resData': [
          {'idx': 1, 'text': '오늘의 나에게', 'created_time': '2020-01-01T00:00:00.000Z'},
        ],
      }),
      queryParameters: {'skip': 0},
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [dioProvider.overrideWithValue(dio)],
        child: MaterialApp(theme: buildAppTheme(), home: const LettersScreen()),
      ),
    );
    // 카드 흔들림이 무한 애니메이션이라 pumpAndSettle 대신 pump 로 비동기 로드만 처리한다.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text(LetterStrings.headerTitle), findsOneWidget);
    expect(find.text(LetterStrings.writeCta), findsOneWidget);
    expect(find.byIcon(Icons.mail_outline), findsWidgets);
  });
}
