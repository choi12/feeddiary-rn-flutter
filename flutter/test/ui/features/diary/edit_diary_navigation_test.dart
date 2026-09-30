// 일기 수정 내비게이션 — 상세 → 수정 → 제출 뒤 상세가 한 번만 쌓이고 수정 내용을 보이며, 뒤로 한 번이면 목록 (widget test).
import 'package:feeddiary/data/models/diary.dart';
import 'package:feeddiary/data/models/user.dart';
import 'package:feeddiary/data/services/demo_api_adapter.dart';
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:feeddiary/domain/models/sign_in_type.dart';
import 'package:feeddiary/routing/auth_state.dart';
import 'package:feeddiary/routing/routes.dart';
import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/app_theme.dart';
import 'package:feeddiary/ui/features/diary/create_diary_screen.dart';
import 'package:feeddiary/ui/features/diary/diary_detail_screen.dart';
import 'package:feeddiary/utils/cache_policy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('상세에서 수정·제출하면 기존 상세로 돌아와 수정 내용을 보이고, 뒤로 한 번이면 목록이다', (tester) async {
    final dio = buildDio(TokenStorage(const FlutterSecureStorage()))
      ..httpClientAdapter = DemoApiAdapter(latency: Duration.zero);
    final container = ProviderContainer(retry: (_, _) => null, overrides: [dioProvider.overrideWithValue(dio)]);
    addTearDown(container.dispose);
    container
        .read(authControllerProvider.notifier)
        .setUser(
          User(
            idx: 1,
            account: 'demo@example.com',
            userId: 'mock_user_id',
            nickname: '새싹이',
            image: '',
            background: '',
            character: 'Chick',
            type: SignInType.google,
            createdAt: DateTime.utc(2026),
            token: 'tok',
            fcmToken: '',
          ),
        );

    // 앱 라우터와 같은 경로 등록 순서(diaryWrite 가 diaryDetail 보다 먼저)의 최소 라우터.
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, _) => Scaffold(
            body: TextButton(onPressed: () => context.push(Routes.diaryDetailPath(1001)), child: const Text('목록')),
          ),
        ),
        GoRoute(
          path: Routes.diaryWrite,
          builder: (_, state) => CreateDiaryScreen(initial: state.extra as MyDiary?),
        ),
        GoRoute(
          path: Routes.diaryDetail,
          builder: (_, state) => DiaryDetailScreen(diaryIdx: int.parse(state.pathParameters['idx']!)),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(theme: buildAppTheme(), routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('목록'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(FeedIcons.more));
    await tester.pumpAndSettle();
    await tester.tap(find.text('수정'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '수정한 본문');
    await tester.pump();
    await tester.tap(find.text('수정하기'));
    await tester.pumpAndSettle();

    expect(find.byType(CreateDiaryScreen, skipOffstage: false), findsNothing);
    expect(find.byType(DiaryDetailScreen, skipOffstage: false), findsOneWidget);
    expect(find.text('수정한 본문'), findsOneWidget);

    router.pop();
    await tester.pumpAndSettle();
    expect(find.byType(DiaryDetailScreen, skipOffstage: false), findsNothing);
    expect(find.text('목록'), findsOneWidget);

    await tester.pump(CachePolicy.standardGcTime + const Duration(seconds: 1)); // cacheFor 폐기 타이머 소진
  });
}
