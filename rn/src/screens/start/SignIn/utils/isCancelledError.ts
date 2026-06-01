export const isCancelledError = (error: unknown): boolean => {
  if (error && typeof error === 'object' && 'message' in error) {
    const errorMessage = (error.message as string)?.toLowerCase() || '';
    const errorCode = 'code' in error ? String(error.code) : '';

    return (
      // iOS Google 로그인 취소
      errorCode === '-5' ||
      // iOS Apple 로그인 취소
      errorCode === '1000' ||
      errorMessage.includes('cancelled') ||
      errorMessage.includes('canceled') ||
      // Android Apple 로그인 취소
      errorMessage.includes('e_signin_cancelled_error')
    );
  }

  return false;
};
