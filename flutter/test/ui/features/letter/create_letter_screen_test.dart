// CreateLetterScreen 위젯 스모크 — 입력창·안내·보내기 버튼 렌더 (widget test).
import 'package:feeddiary/ui/core/theme/app_theme.dart';
import 'package:feeddiary/ui/features/letter/create_letter_screen.dart';
import 'package:feeddiary/ui/features/letter/letter_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('편지 작성 화면이 입력창·안내·보내기 버튼을 렌더한다', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(theme: buildAppTheme(), home: const CreateLetterScreen()),
      ),
    );
    await tester.pump();

    expect(find.text(LetterStrings.writeTitle), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text(LetterStrings.info), findsOneWidget);
    expect(find.text(LetterStrings.sendButton), findsOneWidget);
  });
}
