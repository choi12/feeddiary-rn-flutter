// DiaryCalendar 위젯 — 월 데이터 로딩 중에는 스피너 없이 카드 영역을 비워 둔다(RN CalendarList 대응, widget test).
import 'package:feeddiary/data/services/demo_api_adapter.dart';
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:feeddiary/ui/core/theme/app_theme.dart';
import 'package:feeddiary/ui/features/diary/widgets/diary_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('월 데이터를 불러오는 동안 캘린더에 로딩 스피너가 보이지 않는다', (tester) async {
    final dio = buildDio(TokenStorage(const FlutterSecureStorage()))
      ..httpClientAdapter = DemoApiAdapter(latency: const Duration(milliseconds: 600));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [dioProvider.overrideWithValue(dio)],
        child: MaterialApp(
          theme: buildAppTheme(),
          home: const Scaffold(body: DiaryCalendar()),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    await tester.pump(const Duration(seconds: 1)); // 응답 도착 → 지연 타이머 소진
    await tester.pumpAndSettle();
  });
}
