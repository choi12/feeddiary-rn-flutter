export const TEXT = {
  UPDATE: {
    CHECKING_VERSION: '앱 버전 확인 중...',
    LATEST_VERSION: '최신 버전이에요.',
    required: (version: string) => `최신 버전(${version})으로 업데이트해 주세요.`,
  },
  LOCK: {
    PASSWORD_ENTER: '비밀번호를 입력해 주세요.',
    PASSWORD_CONFIRM: '한 번 더 입력해 주세요.',
  },
  MISSION: {
    DIARY: {
      TITLE: '일기 쓰기',
      CONTENT: '일기를 작성해 보세요.',
    },
    VISIBLE: {
      TITLE: '일기 공개하기',
      CONTENT: '일기 설정을 공개로 전환해 보세요.',
    },
    COMMENT: {
      TITLE: '댓글 달기',
      CONTENT: '일기에 댓글을 작성해 보세요.',
    },
    LIKE: {
      TITLE: '좋아요 누르기',
      CONTENT: '다른 유저의 일기에 좋아요를 눌러 보세요.',
    },
  },
  REWARD: {
    WATERING: '물 주기',
    LOVE: '사랑 주기',
  },
  DIARY: {
    MY_DIARY_EMPTY: '나의 첫 일기를 작성해 보세요 :D',
    COMMUNITY_EMPTY: '공유된 일기가 없어요.',
  },
  COMMENT: {
    EMPTY: '첫 댓글을 작성해 주세요 :D',
  },
  ERROR: {
    RETRY: '다시 시도',
    GO_BACK: '돌아가기',
  },
  LETTER: {
    LETTER_EMPTY: '나에게 첫 편지를 보내 보세요 :D',
  },
  PLACEHOLDER: {
    DIARY: '나의 하루를 기록하고, \n다른 사람들과 공유해 보세요.',
    REPORT: '신고 사유를 입력해 주세요.',
    NICKNAME: '한글, 영어, 숫자 2~8자',
    COMMENT: '댓글 추가...',
    LETTER: '오늘의 나에게...',
  },
} as const;
