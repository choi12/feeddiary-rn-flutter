export const MESSAGE = {
  SYSTEM: {
    WELCOME: '새싹일기에 오신 것을 환영합니다 :D',
    EXIT: "'뒤로' 버튼을 한 번 더 누르면 종료돼요.",
    TRY_AGAIN: '잠시 후 다시 시도해 주세요.',
    ERROR_PREFIX: '🚨 에러 발생: ',
  },
  ACCOUNT: {
    LOGGED_OUT: '로그아웃 되었어요.',
    ACCOUNT_DELETED: '계정이 삭제되었어요.',
    PROFILE_UPDATED: '프로필이 수정되었어요.',
  },
  LOCK: {
    SET_PASSWORD_FIRST: '먼저 비밀번호를 설정해야 해요.',
    PASSWORD_MISMATCH: '비밀번호가 일치하지 않아요.',
    PASSWORD_SET: '비밀번호가 설정되었어요.',
    APP_LOCK_ENABLED: '앱 실행 시 비밀번호 잠금을 사용해요.',
  },
  DIARY: {
    updated: (isEdit: boolean) => `일기가 ${isEdit ? '수정' : '등록'}되었어요.`,
    PUBLISHED: '일기가 공개되었어요.',
    UNPUBLISHED: '일기가 비공개로 설정되었어요.',
    DELETED: '일기가 삭제되었어요.',
    LIKE_MY_DIARY: '다른 사람의 일기에만 좋아요를 할 수 있어요.',
  },
} as const;
