// 대표 화면 골든 — 데모 시드(DemoApiAdapter)로 채운 6개 화면의 시각 스냅샷(비주얼 패리티 회귀 가드).
// Lottie/상대시각/네트워크 이미지가 있는 화면(화분·상세·공유)은 비결정적이라 제외했다.
import 'package:feeddiary/data/models/user.dart';
import 'package:feeddiary/data/services/demo_api_adapter.dart';
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:feeddiary/domain/models/sign_in_type.dart';
import 'package:feeddiary/routing/auth_state.dart';
import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/app_theme.dart';
import 'package:feeddiary/ui/features/auth/create_profile_screen.dart';
import 'package:feeddiary/ui/features/auth/sign_in_screen.dart';
import 'package:feeddiary/ui/features/diary/my_diary_screen.dart';
import 'package:feeddiary/ui/features/flowerpot/mission_screen.dart';
import 'package:feeddiary/ui/features/setting/setting_screen.dart';
import 'package:feeddiary/ui/features/setting/update_profile_screen.dart';
import 'package:feeddiary/utils/cache_policy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

final _testUser = User(
  idx: 1,
  account: 'demo@example.com',
  userId: 'demo_user_1',
  nickname: '새싹이',
  image: '',
  background: '#FFE4B5',
  character: 'Chick',
  type: SignInType.google,
  createdAt: DateTime.utc(2026),
  token: 'tok',
  fcmToken: '',
);

/// 화면을 데모 어댑터로 띄운다. dioProvider 를 DemoApiAdapter 로 교체해 전 도메인 시드를 결정적으로 제공한다.
Future<void> _pumpScreen(WidgetTester tester, Widget screen, {bool withUser = false}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final dio = buildDio(TokenStorage(const FlutterSecureStorage()))
    ..httpClientAdapter = DemoApiAdapter(latency: Duration.zero);
  final container = ProviderContainer(retry: (_, _) => null, overrides: [dioProvider.overrideWithValue(dio)]);
  addTearDown(container.dispose);
  if (withUser) container.read(authControllerProvider.notifier).setUser(_testUser);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(theme: buildAppTheme(), debugShowCheckedModeBanner: false, home: screen),
    ),
  );
  await tester.pumpAndSettle();
}

/// 에셋 이미지는 위젯 테스트에서 비동기 디코딩되므로 골든 전에 강제로 디코딩·재페인트한다.
Future<void> _settleImages(WidgetTester tester) async {
  await tester.runAsync(() async {
    for (final element in find.byType(Image).evaluate()) {
      await precacheImage((element.widget as Image).image, element);
    }
  });
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('sign_in 골든', (tester) async {
    await _pumpScreen(tester, const SignInScreen());
    await _settleImages(tester);
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/screen_sign_in.png'));
  });

  testWidgets('create_profile 골든', (tester) async {
    await _pumpScreen(
      tester,
      const CreateProfileScreen(
        info: NewUserInfo(uid: 'u', email: 'e@e.com', type: SignInType.google),
      ),
    );
    await _settleImages(tester);
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/screen_create_profile.png'));
  });

  testWidgets('my_diary(카드 뷰) 골든', (tester) async {
    await _pumpScreen(tester, const MyDiaryScreen());
    // 기본은 캘린더(현재 월·비결정적)라 카드 뷰로 전환해 시드 카드를 캡처한다.
    await tester.tap(find.byIcon(FeedIcons.listView));
    await tester.pumpAndSettle();
    await _settleImages(tester);
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/screen_my_diary.png'));
    // 캘린더→카드 전환으로 monthlyDiariesProvider 가 listener 를 잃어 cacheFor 폐기 타이머가 걸린다.
    // 종료 전 시간을 진행시켜 타이머를 소진한다(테스트의 pending-timer 검증 통과).
    await tester.pump(CachePolicy.standardGcTime + const Duration(minutes: 1));
  });

  testWidgets('mission 골든', (tester) async {
    await _pumpScreen(tester, const MissionScreen());
    await _settleImages(tester);
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/screen_mission.png'));
  });

  testWidgets('setting 골든', (tester) async {
    await _pumpScreen(tester, const SettingScreen(), withUser: true);
    await _settleImages(tester);
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/screen_setting.png'));
  });

  testWidgets('update_profile 골든', (tester) async {
    await _pumpScreen(tester, const UpdateProfileScreen(), withUser: true);
    await _settleImages(tester);
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/screen_update_profile.png'));
  });
}
