// feedDiary 앱 루트 — MaterialApp.router 로 GoRouter + 디자인 토큰 테마를 조립. builder 로 잠금 가드(LockGate)와 웹 폰 프레임을 라우터 위에 얹는다.
import 'package:feeddiary/routing/app_router.dart';
import 'package:feeddiary/ui/core/theme/app_theme.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/features/setting/widgets/lock_gate.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 앱 루트 위젯. [appRouterProvider]의 GoRouter 설정과 [buildAppTheme] 테마를
/// MaterialApp.router 에 연결하고, [LockGate]로 Navigator 위에 잠금 오버레이를 얹는다(A-6).
/// 웹(데스크톱 폭)에서는 폰 앱이 늘어나 보이므로 [_WebPhoneFrame]으로 폰 폭(센터) 프레임에 담는다.
class FeedDiaryApp extends ConsumerWidget {
  const FeedDiaryApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: '새싹일기',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      routerConfig: router,
      builder: (context, child) => _WebPhoneFrame(child: LockGate(child: child ?? const SizedBox.shrink())),
    );
  }
}

/// 웹 전용 폰 프레임 — 데스크톱처럼 넓은 화면에선 앱을 폰 폭(센터)으로 가두고 배경을 채운다.
/// RN 스크린샷이 폰 폭이라 비교가 맞고(폰 logical px = Flutter logical px), `MediaQuery.size`를 읽는
/// 화면(화분 등)이 폰 폭으로 계산되도록 MediaQuery 도 함께 폰 폭으로 덮는다. 네이티브/좁은 화면은 그대로 통과.
class _WebPhoneFrame extends StatelessWidget {
  const _WebPhoneFrame({required this.child});

  final Widget child;

  /// 데모용 폰 폭(iPhone 계열 logical width).
  static const double _phoneWidth = 390;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    // 네이티브 앱이거나(웹이 아니거나) 이미 폰 폭 이하(모바일 브라우저)면 프레임 없이 그대로.
    if (!kIsWeb || media.size.width <= _phoneWidth) {
      return child;
    }
    return ColoredBox(
      color: FeedPalette.darkBlack,
      child: Center(
        child: ClipRect(
          child: SizedBox(
            width: _phoneWidth,
            child: MediaQuery(
              data: media.copyWith(size: Size(_phoneWidth, media.size.height)),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
