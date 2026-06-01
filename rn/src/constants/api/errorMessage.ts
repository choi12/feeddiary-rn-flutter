export const ERROR_MESSAGES = {
  DEFAULT: '문제가 발생했습니다. 잠시 후 다시 시도해 주세요.',
  NETWORK: '인터넷 연결을 확인해 주세요.',
  TIMEOUT: '요청 시간이 초과되었습니다. 다시 시도해 주세요.',
  UNAUTHORIZED: '계정 정보를 확인해 주세요.',
  FORBIDDEN: '접근 권한이 없습니다.',
  NOT_FOUND: '요청하신 리소스를 찾을 수 없습니다.',
  CONFLICT: '이미 존재하는 리소스입니다.',
  SERVER_ERROR: '서버 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.',
} as const;
