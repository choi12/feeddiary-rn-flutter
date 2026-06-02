// 인증 상태 컨트롤러 — 세션 복원·로그인·회원가입·로그아웃. GoRouter redirect 가 구독. RN useSignIn/useSignUp/useSignOut 대응.
import 'dart:typed_data';

import 'package:feeddiary/config/app_config.dart';
import 'package:feeddiary/data/models/user.dart';
import 'package:feeddiary/data/repositories/auth_repository.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/domain/models/sign_in_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_state.freezed.dart';
part 'auth_state.g.dart';

/// 인증 상태. [unknown]은 부팅 후 세션 복원 판별 중(splash 유지)을 뜻한다.
enum AuthStatus { unknown, unauthenticated, authenticated }

/// 앱 전역 인증 상태. router 는 [status]만, 화면은 [user]를 사용한다.
@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({required AuthStatus status, User? user}) = _AuthState;
}

/// 신규 사용자 정보 — 로그인 시 미가입 사용자를 CreateProfile 로 넘길 때 사용(GoRouter `extra`).
class NewUserInfo {
  const NewUserInfo({required this.uid, required this.email, required this.type});

  final String uid;
  final String email;
  final SignInType type;
}

/// 인증 흐름을 조율하는 컨트롤러. RN `useSignIn`/`useSignUp`/`useSignOut` 의 오케스트레이션을
/// 하나의 Riverpod Notifier 로 모은다. [build]는 [AuthStatus.unknown]을 반환하고, 실제 세션 복원은
/// splash 화면이 [restore]를 트리거한다(RN `Update` 화면이 `useAppUpdate` 로 트리거하는 것과 대응).
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  /// 데모 모드 FCM 토큰(실제 FCM 미연동 — 후속).
  static const String _demoFcmToken = '';

  @override
  AuthState build() => const AuthState(status: AuthStatus.unknown);

  /// 저장된 토큰으로 세션을 복원한다. RN `useSignIn.autoSignIn`(+ `Update` 진입).
  /// 토큰이 없으면 unauthenticated, 있으면 자동 로그인 시도 후 authenticated. 실패 시 토큰을 비우고 unauthenticated.
  Future<void> restore() async {
    final token = ref.read(tokenStorageProvider).token;
    if (token == null || token.isEmpty) {
      state = const AuthState(status: AuthStatus.unauthenticated);
      return;
    }
    try {
      final user = await ref.read(authRepositoryProvider).autoSignIn(accessToken: token);
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } on AppException {
      await ref.read(tokenStorageProvider).clear();
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  /// 로그인 시도. 성공 시 authenticated 로 전환하고 `null` 반환(redirect 가 home 으로).
  /// 신규 사용자(401)면 [NewUserInfo]를 반환(화면이 CreateProfile 로 분기). 그 외 에러는 [AppException] throw.
  Future<NewUserInfo?> signIn(SignInType type) async {
    final credential = await _resolveCredential(type);
    try {
      final user = await ref.read(authRepositoryProvider).signIn(userId: credential.uid, fcmToken: _demoFcmToken);
      await _completeSignIn(user);
      return null;
    } on UnauthorizedException {
      // 신규 사용자 — 인증 상태는 그대로(unauthenticated)이고, 화면이 CreateProfile 로 이동한다.
      return NewUserInfo(uid: credential.uid, email: credential.email, type: type);
    }
  }

  /// 프로필 작성 후 회원가입. 성공 시 authenticated 로 전환. RN `useSignUp.handleSignUp`.
  /// 프로필 이미지는 사진([imageBytes]) 또는 캐릭터([character]+[background]) 중 하나다.
  Future<void> signUp({
    required NewUserInfo info,
    required String nickname,
    required String character,
    String background = '',
    Uint8List? imageBytes,
  }) async {
    final user = await ref
        .read(authRepositoryProvider)
        .signUp(
          userId: info.uid,
          email: info.email,
          type: info.type,
          nickname: nickname,
          background: background,
          character: character,
          fcmToken: _demoFcmToken,
          imageBytes: imageBytes,
        );
    await _completeSignIn(user);
  }

  /// 로그아웃. 서버 정리 후 토큰을 비우고 unauthenticated 로 전환. RN `useSignOut`+`useAuthCleanup`.
  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    await ref.read(tokenStorageProvider).clear();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  /// 프로필 수정 후 사용자 정보를 갱신한다(인증 상태는 유지). RN user slice `saveUser` 대응.
  void setUser(User user) {
    state = state.copyWith(user: user);
  }

  /// 토큰 저장 + authenticated 전환. RN `completeSignIn`(잠금/프리페치는 후속 PR).
  Future<void> _completeSignIn(User user) async {
    await ref.read(tokenStorageProvider).save(user.token);
    state = AuthState(status: AuthStatus.authenticated, user: user);
  }

  /// 로그인 자격증명 획득. 데모 모드는 OAuth 를 우회하고 데모 자격증명을 반환한다(RN useSignIn 의 USE_MOCK 분기).
  Future<({String uid, String email})> _resolveCredential(SignInType type) async {
    if (AppConfig.useMock) {
      return (uid: 'mock_user_id', email: 'demo@example.com');
    }
    // 실제 OAuth 흐름(후속 PR): google_sign_in / sign_in_with_apple 로 토큰 획득 →
    // (RN) Firebase signInWithCredential 로 UID → 자체 `/auth/sign-in`. 플랫폼별 Apple(iOS 네이티브 / Android 웹 리다이렉트).
    throw UnimplementedError('실제 OAuth 로그인은 후속 PR에서 연동합니다(현재 데모 모드 전용).');
  }
}
