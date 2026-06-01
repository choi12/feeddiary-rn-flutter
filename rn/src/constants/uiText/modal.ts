export const MODAL_CONTENT = {
  UPDATE: {
    REQUIRED: '최신 버전으로 업데이트해 주세요 :D',
  },
  ACCOUNT: {
    LOGOUT_CONFIRM: '정말 로그아웃 하시겠어요?',
    DELETE_CONFIRM: '정말 새싹일기를 떠나실 건가요?',
  },
  MISSION: {
    REWARD: '미션 보상을 획득했어요!',
  },
  DIARY: {
    DELETE_CONFIRM: '일기를 삭제하시겠어요?',
    REPORT_COMPLETE: '신고 접수 완료!\n해당 유저가 차단되었어요.',
    SORT: {
      LATEST: '최신글',
      POPULAR: '인기글',
    },
    VISIBILITY: {
      toggle: (isVisible: boolean) => `${isVisible ? '비공개' : '공개'}로 전환하기`,
      EDIT: '수정',
      DELETE: '삭제',
    },
  },
  COMMENT: {
    DELETE_CONFIRM: '댓글을 삭제하시겠어요?',
  },
  LETTER: {
    DELETE_CONFIRM: '편지를 삭제하시겠어요?',
  },
} as const;

export const MODAL_BUTTON = {
  COMMON: {
    CLOSE: '닫기',
    CONFIRM: '확인',
    DELETE: '삭제하기',
  },
  UPDATE: {
    LATER: '다음에 할래요',
    CONFIRM: '네 알겠어요 !',
  },
  ACCOUNT: {
    LOGOUT: '로그아웃하기',
    DELETE: '탈퇴하기',
  },
  REWARD: {
    USE: '사용하러 가기',
  },
} as const;
