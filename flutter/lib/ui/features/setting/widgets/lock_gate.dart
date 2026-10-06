// 앱 잠금 가드 — resume/콜드스타트 시 잠금 오버레이를 라우터 위에 띄움. RN components/guard/LockScreenGuard(AppState) 대응.
import 'package:feeddiary/data/services/lock_storage.dart';
import 'package:feeddiary/routing/auth_state.dart';
import 'package:feeddiary/ui/features/setting/lock_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// [MaterialApp.router]의 builder 에서 Navigator([child]) 위를 감싸 잠금 오버레이를 얹는 가드.
///
/// RN 은 `LockScreenGuard`가 AppState background→active 에서 LockScreen 으로 navigate 하고
/// 콜드스타트는 별도 분기한다. Flutter 는 `AppLifecycleListener`(resume) + 콜드스타트를 단일 오버레이로 통합한다
/// (IndexedStack 셸·푸시 라우트를 한 번에 덮음 — RN 의 navigate+BackHandler 분기보다 단순. README 비교 포인트).
/// 잠금은 인증된 사용자에게만 적용한다(잠금 설정은 로그인 상태에서만 가능 → 미인증 화면은 덮지 않음).
///
/// 오버레이는 Navigator 밖이라 `PopScope` 가 붙을 라우트가 없다. 그래서 잠금 중 Android 뒤로가기는
/// `didPopRoute` 에서 직접 소비하고, 첫 화면에서도 시스템이 가로채지 않게 프레임워크가 받는다고 알린다(predictive back).
class LockGate extends ConsumerStatefulWidget {
  const LockGate({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<LockGate> createState() => _LockGateState();
}

class _LockGateState extends ConsumerState<LockGate> with WidgetsBindingObserver {
  late final AppLifecycleListener _listener;
  bool _locked = false;

  /// 라우터(Navigator)가 마지막으로 알린 pop 가능 여부. 해제 뒤 플랫폼에 되돌려 줄 값.
  bool _routerCanHandlePop = false;

  @override
  void initState() {
    super.initState();
    // 콜드스타트 — 잠금이 켜져 있으면 잠근 채로 시작(인증되면 오버레이 노출).
    _locked = ref.read(lockStorageProvider).useLock;
    _listener = AppLifecycleListener(onResume: _onResume);
    WidgetsBinding.instance.addObserver(this);
  }

  bool get _showing => _locked && ref.read(authControllerProvider).status == AuthStatus.authenticated;

  /// 잠금 오버레이가 떠 있으면 Android 뒤로가기를 소비한다(아래 라우터로 넘기지 않음).
  @override
  Future<bool> didPopRoute() async => _showing;

  /// 라우터가 「pop 불가」를 알려도 잠금 중이면 「프레임워크가 받음」으로 바꿔 올린다.
  bool _onNavigation(NavigationNotification notification) {
    _routerCanHandlePop = notification.canHandlePop;
    if (!_showing || notification.canHandlePop) return false;
    const NavigationNotification(canHandlePop: true).dispatch(context);
    return true;
  }

  /// 잠금이 걸리거나 풀릴 때 플랫폼에 현재 값을 다시 알린다.
  void _reportBackHandling() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      NavigationNotification(canHandlePop: _showing || _routerCanHandlePop).dispatch(context);
    });
  }

  void _onResume() {
    if (ref.read(lockStorageProvider).useLock) {
      setState(() => _locked = true);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authenticated = ref.watch(authControllerProvider).status == AuthStatus.authenticated;
    _reportBackHandling();
    return NotificationListener<NavigationNotification>(
      onNotification: _onNavigation,
      child: Stack(
        children: [
          // Android 기본 전환(predictive back)은 스와이프 제스처를 라우트가 직접 가져가 didPopRoute 를 거치지 않는다.
          // 잠금 중에만 일반 전환으로 바꿔 제스처도 위 didPopRoute 로 떨어지게 한다. 위젯 타입을 갈아 끼우면
          // Router 아래가 다시 마운트돼 화면 스택이 날아가므로 Theme 은 늘 감싸 두고 값만 바꾼다.
          Theme(
            data: _showing
                ? Theme.of(context).copyWith(
                    pageTransitionsTheme: const PageTransitionsTheme(
                      builders: {TargetPlatform.android: FadeForwardsPageTransitionsBuilder()},
                    ),
                  )
                : Theme.of(context),
            child: widget.child,
          ),
          if (_locked && authenticated) LockOverlay(onUnlocked: () => setState(() => _locked = false)),
        ],
      ),
    );
  }
}
