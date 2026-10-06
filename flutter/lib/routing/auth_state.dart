// 인증 상태 컨트롤러 — 세션 복원·로그인·회원가입·로그아웃. GoRouter redirect 가 구독. RN useSignIn/useSignUp/useSignOut 대응.
import 'dart:typed_data';

import 'package:feeddiary/config/app_config.dart';
import 'package:feeddiary/data/models/user.dart';
import 'package:feeddiary/data/repositories/auth_repository.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/domain/models/sign_in_type.dart';
import 'package:feeddiary/ui/features/community/comments_controller.dart';
import 'package:feeddiary/ui/features/community/community_list_controller.dart';
import 'package:feeddiary/ui/features/community/diary_likes.dart';
import 'package:feeddiary/ui/features/diary/diary_detail_controller.dart';
import 'package:feeddiary/ui/features/diary/diary_list_controller.dart';
import 'package:feeddiary/ui/features/diary/monthly_diaries_provider.dart';
import 'package:feeddiary/ui/features/flowerpot/flowerpot_controller.dart';
import 'package:feeddiary/ui/features/flowerpot/mission_controller.dart';
import 'package:feeddiary/ui/features/letter/letter_list_controller.dart';
import 'package:feeddiary/utils/logger.dart';
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
  /// 토큰이 없으면 unauthenticated, 있으면 자동 로그인 시도 후 authenticated.
  /// 401 이면 토큰을 비우고, 네트워크·서버 오류면 토큰을 남긴 채 unauthenticated(다음 실행에서 다시 시도 — RN 과 같음).
  Future<void> restore() async {
    final token = ref.read(tokenStorageProvider).token;
    if (token == null || token.isEmpty) {
      state = const AuthState(status: AuthStatus.unauthenticated);
      return;
    }
    try {
      final user = await ref.read(authRepositoryProvider).autoSignIn(accessToken: token);
      // 원본 서버는 자동 로그인마다 토큰을 새로 발급해 DB 에 넣고, 다음 자동 로그인은 그 토큰으로만 통과시킨다.
      // 보안 저장소 쓰기가 실패해도(Keystore 손상 등) 캐시는 이미 새 토큰이라 이번 세션은 그대로 진행한다.
      try {
        await ref.read(tokenStorageProvider).save(user.token);
      } catch (error, stackTrace) {
        AppLogger.error('자동 로그인 토큰 저장 실패', error: error, stackTrace: stackTrace);
      }
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } on UnauthorizedException {
      await ref.read(tokenStorageProvider).clear();
      state = const AuthState(status: AuthStatus.unauthenticated);
    } on AppException {
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

  /// 세션 동안 유지되는 사용자 데이터(keepAlive·수동 AsyncNotifierProvider·월별 캐시)를 무효화해 새 세션에
  /// 이전 사용자의 목록·좋아요·화분이 남지 않게 한다. RN `useAuthCleanup` 의 queryClient.clear() 대응.
  /// 일기 상세·댓글 family 도 `cacheFor(realtime)`로 구독자가 떠난 뒤 30초 남으므로 family 전체를 비운다 — 남으면
  /// 이전 사용자 기준의 공개 여부·댓글(`nickname == 내 닉네임` 삭제 버튼)이 새 세션에 잠깐 보인다.
  /// 로그아웃이 아닌 새 세션 시작에서 비운다 — 로그아웃 시점엔 아직 화면이 구독 중이라 invalidate 가 토큰 없이
  /// 즉시 재조회하지만, 로그인 화면에서는 구독자가 없어 표시만 해 두고 새 토큰으로 처음 읽을 때 불러온다.
  void _clearUserCache() {
    ref
      ..invalidate(diaryListProvider)
      ..invalidate(monthlyDiariesProvider)
      ..invalidate(diaryDetailControllerProvider)
      ..invalidate(commentsControllerProvider)
      ..invalidate(communityListProvider)
      ..invalidate(diaryLikesProvider)
      ..invalidate(letterListProvider)
      ..invalidate(flowerpotControllerProvider)
      ..invalidate(missionsControllerProvider);
  }

  /// 이전 세션 캐시 정리 + 토큰 저장 + authenticated 전환. RN `completeSignIn`(잠금/프리페치는 데모 범위 밖 — 실 연동 시 추가).
  Future<void> _completeSignIn(User user) async {
    _clearUserCache();
    await ref.read(tokenStorageProvider).save(user.token);
    state = AuthState(status: AuthStatus.authenticated, user: user);
  }

  /// 로그인 자격증명 획득. 데모 모드는 OAuth 를 우회하고 데모 자격증명을 반환한다(RN useSignIn 의 USE_MOCK 분기).
  Future<({String uid, String email})> _resolveCredential(SignInType type) async {
    if (AppConfig.useMock) {
      return (uid: 'mock_user_id', email: 'demo@example.com');
    }
    // 실제 OAuth 흐름(데모 범위 밖 — 실서버 연동 시): google_sign_in / sign_in_with_apple 로 토큰 획득 →
    // (RN) Firebase signInWithCredential 로 UID → 자체 `/auth/sign-in`. 플랫폼별 Apple(iOS 네이티브 / Android 웹 리다이렉트).
    throw UnimplementedError('실제 OAuth 로그인은 실서버 연동 시 구현됩니다(데모 모드 전용 스텁).');
  }
}
