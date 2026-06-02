// 프로필 작성 폼 컨트롤러 — 닉네임 디바운스 검증·프로필 이미지(사진/캐릭터)·가입. RN ProfileProvider + useCheckNickname + useSignUp 대응.
import 'dart:async';
import 'dart:typed_data';

import 'package:feeddiary/config/validation_rules.dart';
import 'package:feeddiary/data/repositories/auth_repository.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/routing/auth_state.dart';
import 'package:feeddiary/ui/features/setting/local_avatar.dart';
import 'package:feeddiary/ui/features/setting/profile_image_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_profile_controller.freezed.dart';
part 'create_profile_controller.g.dart';

/// 닉네임 검증 상태. RN `NicknameValidationStatus`(success/duplicate/regex/undefined).
enum NicknameStatus { success, duplicate, regex }

/// CreateProfile 폼 상태. RN ProfileProvider context value 대응(닉네임 + 프로필 이미지[사진/캐릭터+배경]).
@freezed
abstract class CreateProfileState with _$CreateProfileState {
  const factory CreateProfileState({
    @Default('') String nickname,
    NicknameStatus? nicknameStatus,
    String? character,
    @Default('') String background,
    ProfileImageType? imageType,
    Uint8List? imageBytes,
  }) = _CreateProfileState;

  const CreateProfileState._();

  /// 사진 모드 여부.
  bool get usePhoto => imageType == ProfileImageType.photo;

  /// 프로필 이미지를 골랐는가 — 사진 바이트가 있거나 캐릭터가 선택됨. RN ProfileImageSection 선택 여부.
  bool get _hasProfileImage => usePhoto ? imageBytes != null : (character != null && character!.isNotEmpty);

  /// 가입 가능 조건 — 닉네임 성공 + 프로필 이미지 선택. RN `isSignUpDisabled`의 긍정형.
  bool get canSubmit => nicknameStatus == NicknameStatus.success && _hasProfileImage;
}

/// 프로필 작성 폼 컨트롤러. 닉네임은 입력 디바운스 후 정규식 → 중복검사 순으로 검증하고,
/// 프로필 이미지(사진 업로드/캐릭터 프리셋)를 고른 뒤 가입한다. RN `useCheckNickname` + `ProfileProvider` + `useSignUp` ViewModel.
@riverpod
class CreateProfileController extends _$CreateProfileController {
  static const Duration _debounce = Duration(milliseconds: 400);

  Timer? _timer;

  @override
  CreateProfileState build() {
    ref.onDispose(() => _timer?.cancel());
    return const CreateProfileState();
  }

  /// 닉네임 입력. 값 갱신 + 상태 초기화 후 디바운스하여 [validateNickname]을 호출한다.
  void setNickname(String value) {
    state = state.copyWith(nickname: value, nicknameStatus: null);
    _timer?.cancel();
    _timer = Timer(_debounce, () => validateNickname(value));
  }

  /// 캐릭터 선택. 사진 모드를 해제한다(상호 배타 — RN ProfileImageSection).
  void selectCharacter(String name) {
    state = state.copyWith(imageType: ProfileImageType.character, character: name, imageBytes: null);
  }

  /// 배경색 선택(캐릭터 모드). RN BackgroundSelector.
  void setBackground(String hex) {
    state = state.copyWith(imageType: ProfileImageType.character, background: hex);
  }

  /// 사진 선택. 캐릭터 모드를 해제하고 바이트를 보관한다(상호 배타 — RN ProfileImageSection).
  void pickPhoto(Uint8List bytes) {
    state = state.copyWith(imageType: ProfileImageType.photo, imageBytes: bytes);
  }

  /// 닉네임 검증(디바운스 없이 즉시 — 디바운스 콜백·테스트가 공유). RN `checkNicknameValidity`.
  /// 빈값 → 상태 없음, 정규식 불일치 → regex, 통과 → 중복검사(성공 success / 409 duplicate / 그 외 에러는 상태 해제).
  Future<void> validateNickname(String value) async {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      state = state.copyWith(nicknameStatus: null);
      return;
    }
    if (!ValidationRules.nicknameRegex.hasMatch(trimmed)) {
      state = state.copyWith(nicknameStatus: NicknameStatus.regex);
      return;
    }
    try {
      await ref.read(authRepositoryProvider).checkNickname(trimmed);
      state = state.copyWith(nicknameStatus: NicknameStatus.success);
    } on ConflictException {
      state = state.copyWith(nicknameStatus: NicknameStatus.duplicate);
    } on AppException {
      state = state.copyWith(nicknameStatus: null);
    }
  }

  /// 가입 — 프로필(사진 또는 캐릭터+배경)과 닉네임으로 회원가입 후 세션 아바타 override. RN useSignUp.handleSignUp.
  Future<void> submit(NewUserInfo info) async {
    final usePhoto = state.usePhoto;
    await ref
        .read(authControllerProvider.notifier)
        .signUp(
          info: info,
          nickname: state.nickname.trim(),
          character: usePhoto ? '' : (state.character ?? ''),
          background: usePhoto ? '' : state.background,
          imageBytes: usePhoto ? state.imageBytes : null,
        );
    final localAvatar = ref.read(localAvatarProvider.notifier);
    if (usePhoto && state.imageBytes != null) {
      localAvatar.set(state.imageBytes!);
    } else {
      localAvatar.clear();
    }
  }
}
