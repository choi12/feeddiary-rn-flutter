import { API_CONFIG } from '@/constants';
import { APIError } from '@/types/errors';
import { getErrorMessage } from '@/utils/error/getErrorMessage';

export const formatAPIError = (error: unknown, operation: string) => {
  if (error instanceof Error) {
    error.message = `[${operation}] ${error.message}`;
    throw error; // 원본 에러 타입을 그대로 유지하면서 operation 정보만 추가
  }

  const errorMessage = getErrorMessage(error);
  throw new APIError(API_CONFIG.STATUS.SERVER_ERROR, `[${operation}] ${errorMessage}`, error);
};
