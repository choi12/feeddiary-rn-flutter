// 설정 도메인 문자열 상수 — RN constants/uiText(MESSAGE·TEXT) + 설정 화면 라벨 1:1. 하드코딩 방지.
abstract final class SettingStrings {
  // 메인 설정(RN Setting + UserProfileBox + MenuButtonBox)
  static const String title = '설정';
  static const String editProfile = '내 정보 수정';
  static const String menuLock = '잠금 설정';
  static const String menuSupport = '문의하기';
  static const String menuLicense = '라이선스';
  static const String menuAppVersion = '앱 버전 정보';
  static const String signOut = '로그아웃';
  static const String signOutConfirm = '로그아웃 하시겠어요?';
  static const String signedOut = '로그아웃 되었어요.';

  // 앱 버전(RN AppVersion + TEXT.UPDATE)
  static const String appVersionTitle = '앱 버전 정보';
  static const String latestVersion = '최신 버전이에요.';
  static String updateRequired(String version) => '최신 버전($version)으로 업데이트해 주세요.';
  static String currentVersion(String version) => 'version: $version';

  // 잠금(RN MESSAGE.LOCK + TEXT.LOCK + LockdownSettings/SettingLockPassword)
  static const String lockTitle = '잠금 설정';
  static const String lockUseSwitch = '비밀번호 잠금 사용';
  static const String lockResetPassword = '비밀번호 재설정';
  static const String lockSetTitle = '잠금 비밀번호 설정';
  static const String passwordEnter = '비밀번호를 입력해 주세요.';
  static const String passwordConfirm = '한 번 더 입력해 주세요.';
  static const String unlockTitle = '비밀번호를 입력해 주세요.';
  static const String setPasswordFirst = '먼저 비밀번호를 설정해야 해요.';
  static const String passwordMismatch = '비밀번호가 일치하지 않아요.';
  static const String passwordSet = '비밀번호가 설정되었어요.';
  static const String appLockEnabled = '앱 실행 시 비밀번호 잠금을 사용해요.';
  static const String keypadDeleteLabel = '삭제';

  // 프로필 수정(RN UpdateProfile + NicknameSection + ProfileImageSection + DeleteAccount)
  static const String updateProfileTitle = '프로필 수정';
  static const String nicknameLabel = '닉네임';
  static const String nicknamePlaceholder = '한글, 영어, 숫자 2~8자';
  static const String profileImageLabel = '프로필 이미지';
  static const String pickPhoto = '사진 선택하기';
  static const String pickCharacter = '캐릭터 만들기';
  static const String backgroundLabel = '배경';
  static const String characterLabel = '캐릭터';
  static const String characterPlaceholder = '캐릭터를 선택해 주세요.';
  static const String colorPickerTitle = '배경색을 선택해 주세요.';
  static const String updateSubmit = '수정하기';
  static const String profileUpdated = '프로필이 수정되었어요.';
  static const String nicknameSuccess = '사용 가능한 닉네임이에요.';
  static const String nicknameDuplicate = '이미 사용 중인 닉네임이에요.';
  static const String nicknameRegex = '한글, 영문 또는 숫자 2~8글자로 입력해 주세요.';

  // 계정 탈퇴(RN DeleteAccountButton + MESSAGE.ACCOUNT)
  static const String deleteAccount = '탈퇴하기';
  static const String deleteAccountConfirm = '정말 탈퇴하시겠어요?';
  static const String accountDeleted = '계정이 삭제되었어요.';

  // 공통 다이얼로그 버튼
  static const String confirm = '확인';
  static const String cancel = '닫기';

  // 문의하기(RN sendSupportEmail)
  static const String supportSubject = '[새싹일기] 문의';
  static const String supportUnavailable = '메일 앱을 열 수 없어요.';
}
