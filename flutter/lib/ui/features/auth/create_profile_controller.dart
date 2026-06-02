// 프로필 작성 폼 컨트롤러 — 닉네임 디바운스 검증·캐릭터 선택 상태. RN ProfileProvider + useCheckNickname 대응.
import 'dart:async';

import 'package:feeddiary/config/validation_rules.dart';
import 'package:feeddiary/data/repositories/auth_repository.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_profile_controller.freezed.dart';
part 'create_profile_controller.g.dart';

/// 닉네임 검증 상태. RN `NicknameValidationStatus`(success/duplicate/regex/undefined).
enum NicknameStatus { success, duplicate, regex }

/// CreateProfile 폼 상태. RN ProfileProvider context value 대응(image_picker 보류라 character 경로만).
@freezed
abstract class CreateProfileState with _$CreateProfileState {
  const factory CreateProfileState({@Default('') String nickname, NicknameStatus? nicknameStatus, String? character}) =
      _CreateProfileState;

  const CreateProfileState._();

  /// 가입 가능 조건 — RN `isSignUpDisabled`(닉네임 성공 + 프로필 선택)의 긍정형.
  bool get canSubmit => nicknameStatus == NicknameStatus.success && character != null;
}

/// 프로필 작성 폼 컨트롤러. 닉네임은 입력 디바운스 후 정규식 → 중복검사 순으로 검증한다.
/// RN `useCheckNickname`(debounce + 정규식 + 중복검사) + `ProfileProvider`(캐릭터 선택)를 합친 ViewModel.
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

  /// 캐릭터 선택. RN ProfileProvider 의 onSetCharacter.
  void setCharacter(String character) {
    state = state.copyWith(character: character);
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
}
