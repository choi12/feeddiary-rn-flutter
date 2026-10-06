import { ZodError } from 'zod';

import { MESSAGE } from '@/constants';

export const getErrorMessage = (error: unknown): string => {
  // 응답 계약 위반(zod 검증 실패)은 이슈 JSON 이 message 라 사용자에겐 일반 문구만 — 상세는 reportError 로 간다
  if (error instanceof ZodError) {
    return MESSAGE.SYSTEM.TRY_AGAIN;
  }
  if (error instanceof Error) {
    return error.message;
  }
  if (typeof error === 'string') {
    return error;
  }
  if (typeof error === 'object' && error !== null) {
    if ('message' in error && typeof error.message === 'string') {
      return error.message;
    }
    try {
      return JSON.stringify(error);
    } catch {
      return MESSAGE.SYSTEM.TRY_AGAIN;
    }
  }

  return MESSAGE.SYSTEM.TRY_AGAIN;
};
