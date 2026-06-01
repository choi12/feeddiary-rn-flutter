// 인증 상태 placeholder — GoRouter redirect 가 구독하는 Riverpod Notifier 골격.
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_state.g.dart';

/// 인증 상태. PR① 골격 단계 — 실제 토큰/세션 연동은 auth PR에서 채운다.
enum AuthStatus { unknown, unauthenticated, authenticated }

/// 현재 인증 상태를 노출하는 Notifier. 지금은 [AuthStatus.unauthenticated] 고정 placeholder이며,
/// auth PR에서 토큰 저장소·세션 복원 로직으로 대체한다. GoRouter redirect 가 이 값을 watch 한다.
@riverpod
class AuthController extends _$AuthController {
  @override
  AuthStatus build() => AuthStatus.unauthenticated;
}
