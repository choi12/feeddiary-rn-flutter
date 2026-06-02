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
class LockGate extends ConsumerStatefulWidget {
  const LockGate({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<LockGate> createState() => _LockGateState();
}

class _LockGateState extends ConsumerState<LockGate> {
  late final AppLifecycleListener _listener;
  bool _locked = false;

  @override
  void initState() {
    super.initState();
    // 콜드스타트 — 잠금이 켜져 있으면 잠근 채로 시작(인증되면 오버레이 노출).
    _locked = ref.read(lockStorageProvider).useLock;
    _listener = AppLifecycleListener(onResume: _onResume);
  }

  void _onResume() {
    if (ref.read(lockStorageProvider).useLock) {
      setState(() => _locked = true);
    }
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authenticated = ref.watch(authControllerProvider).status == AuthStatus.authenticated;
    return Stack(
      children: [
        widget.child,
        if (_locked && authenticated) LockOverlay(onUnlocked: () => setState(() => _locked = false)),
      ],
    );
  }
}
