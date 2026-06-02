// CreateDiaryScreen 위젯 스모크 — 작성 폼(스티커/버튼) 렌더 (widget test).
import 'package:feeddiary/ui/core/theme/app_theme.dart';
import 'package:feeddiary/ui/features/diary/create_diary_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('일기 작성 화면이 스티커 영역과 등록 버튼을 렌더한다', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(theme: buildAppTheme(), home: const CreateDiaryScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('오늘의 스티커'), findsOneWidget);
    expect(find.text('일기 등록하기'), findsOneWidget);
  });
}
