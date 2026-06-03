// 프로필 수정 폼 컨트롤러 — 닉네임 검증 재사용·사진/캐릭터·배경·변경 감지·저장. RN UpdateProfile + ProfileProvider + useUpdateProfile 대응.
import 'dart:async';
import 'dart:typed_data';

import 'package:feeddiary/config/validation_rules.dart';
import 'package:feeddiary/data/repositories/auth_repository.dart';
import 'package:feeddiary/data/repositories/profile_repository.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/routing/auth_state.dart';
import 'package:feeddiary/ui/features/auth/create_profile_controller.dart' show NicknameStatus;
import 'package:feeddiary/ui/features/setting/local_avatar.dart';
import 'package:feeddiary/ui/features/setting/profile_image_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_profile_controller.freezed.dart';
part 'update_profile_controller.g.dart';

/// 프로필 수정 폼 상태. 초기값(initial*)을 함께 들고 있어 변경 감지([isDirty])를 자체 계산한다.
@freezed
abstract class UpdateProfileState with _$UpdateProfileState {
  const factory UpdateProfileState({
    required String initialNickname,
    required String initialCharacter,
    required String initialBackground,
    @Default('') String nickname,
    NicknameStatus? nicknameStatus,
    @Default('') String character,
    @Default('') String background,
    ProfileImageType? imageType,
    Uint8List? imageBytes,
  }) = _UpdateProfileState;

  const UpdateProfileState._();

  /// 사진 모드 여부.
  bool get usePhoto => imageType == ProfileImageType.photo;

  /// 닉네임이 유효한가 — 변경이 없으면 유효(재검증 불요), 변경되었으면 중복검사 성공이어야 한다.
  bool get _nicknameValid {
    if (nickname.trim() == initialNickname) return true;
    return nicknameStatus == NicknameStatus.success;
  }

  /// 초기값 대비 변경이 있는가. RN `isUpdateProfileDisabled`의 "변경 없음" 역.
  bool get isDirty {
    if (nickname.trim() != initialNickname) return true;
    if (usePhoto) return imageBytes != null;
    return character != initialCharacter || background != initialBackground;
  }

  /// 저장 가능 조건 — 닉네임 비어있지 않고, 유효하며(성공 또는 무변경), 변경이 있을 때. RN `isUpdateProfileDisabled`의 긍정형.
  bool get canSubmit =>
      nickname.trim().isNotEmpty &&
      nicknameStatus != NicknameStatus.duplicate &&
      nicknameStatus != NicknameStatus.regex &&
      _nicknameValid &&
      isDirty;
}

/// 프로필 수정 폼 컨트롤러. 닉네임은 디바운스 후 검증(CreateProfile 과 동일 로직 재사용)하고,
/// 사진/캐릭터/배경 변경을 추적한다. RN `useUpdateProfile`(변경 감지·FormData) + `useCheckNickname` ViewModel.
@riverpod
class UpdateProfileController extends _$UpdateProfileController {
  static const Duration _debounce = Duration(milliseconds: 400);

  Timer? _timer;

  @override
  UpdateProfileState build() {
    ref.onDispose(() => _timer?.cancel());
    final user = ref.read(authControllerProvider).user;
    final nickname = user?.nickname ?? '';
    final character = user?.character ?? '';
    final background = user?.background ?? '';
    // 초기 모드 — 사진이 있으면 photo, 캐릭터가 있으면 character(데모는 image='' 라 character).
    final hasImage = (user?.image ?? '').isNotEmpty;
    final imageType = hasImage ? ProfileImageType.photo : (character.isNotEmpty ? ProfileImageType.character : null);
    return UpdateProfileState(
      initialNickname: nickname,
      initialCharacter: character,
      initialBackground: background,
      nickname: nickname,
      character: character,
      background: background,
      imageType: imageType,
    );
  }

  /// 닉네임 입력 + 디바운스 검증. 현재 닉네임과 같으면 검증을 건너뛴다(무변경 = 유효).
  void setNickname(String value) {
    state = state.copyWith(nickname: value, nicknameStatus: null);
    _timer?.cancel();
    if (value.trim() == state.initialNickname) return;
    _timer = Timer(_debounce, () => validateNickname(value));
  }

  /// 닉네임 검증(디바운스 콜백·테스트 공유). 정규식 → 중복검사. RN `checkNicknameValidity`.
  Future<void> validateNickname(String value) async {
    final trimmed = value.trim();
    if (trimmed.isEmpty || trimmed == state.initialNickname) {
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

  /// 캐릭터 선택. 사진 모드를 해제한다(상호 배타 — RN ProfileImageSection).
  void selectCharacter(String name) {
    state = state.copyWith(imageType: ProfileImageType.character, character: name, imageBytes: null);
  }

  /// 캐릭터 모드로만 전환(캐릭터 미선택·사진 해제·기존 캐릭터 유지). RN "캐릭터 만들기"→onClearProfileImage.
  void useCharacterMode() {
    state = state.copyWith(imageType: ProfileImageType.character, imageBytes: null);
  }

  /// 배경색 선택(캐릭터 모드). RN BackgroundSelector.
  void setBackground(String hex) {
    state = state.copyWith(imageType: ProfileImageType.character, background: hex);
  }

  /// 사진 선택. 캐릭터 모드를 해제하고 바이트를 보관한다(상호 배타 — RN ProfileImageSection).
  void pickPhoto(Uint8List bytes) {
    state = state.copyWith(imageType: ProfileImageType.photo, imageBytes: bytes);
  }

  /// 저장 — multipart 전송 후 AuthController 사용자 갱신 + 세션 아바타 override. RN useUpdateProfile.submit + saveUser.
  Future<void> submit() async {
    final usePhoto = state.usePhoto;
    final user = await ref
        .read(profileRepositoryProvider)
        .updateProfile(
          nickname: state.nickname.trim(),
          background: usePhoto ? '' : state.background,
          character: usePhoto ? '' : state.character,
          imageBytes: usePhoto ? state.imageBytes : null,
        );
    final localAvatar = ref.read(localAvatarProvider.notifier);
    if (usePhoto && state.imageBytes != null) {
      localAvatar.set(state.imageBytes!);
    } else {
      localAvatar.clear();
    }
    ref.read(authControllerProvider.notifier).setUser(user);
  }

  /// 계정 탈퇴 — 서버 호출 후 로그아웃으로 귀결. RN useDeleteAccount + cleanupUserData.
  Future<void> deleteAccount() async {
    await ref.read(profileRepositoryProvider).deleteAccount();
    ref.read(localAvatarProvider.notifier).clear();
    await ref.read(authControllerProvider.notifier).signOut();
  }
}
