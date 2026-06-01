import { MESSAGE } from '@/constants';

export const getErrorMessage = (error: unknown): string => {
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
