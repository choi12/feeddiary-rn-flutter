// isCancelledError 유틸 테스트 — OAuth 취소 판별 분기 전수
import { isCancelledError } from '@/screens/start/SignIn/utils/isCancelledError';

describe('isCancelledError', () => {
  // code 분기는 message 속성이 함께 있을 때만 평가된다(가드 조건)
  it('detects iOS Google cancel code (-5)', () => {
    expect(isCancelledError({ code: -5, message: 'sign in failed' })).toBe(true);
  });

  it('detects iOS Apple cancel code (1000)', () => {
    expect(isCancelledError({ code: 1000, message: 'sign in failed' })).toBe(true);
  });

  it('returns false for a cancel code without a message property', () => {
    expect(isCancelledError({ code: -5 })).toBe(false);
  });

  it('detects a "cancelled" message (en-GB spelling)', () => {
    expect(isCancelledError({ message: 'User Cancelled the login' })).toBe(true);
  });

  it('detects a "canceled" message (en-US spelling)', () => {
    expect(isCancelledError({ message: 'request was canceled' })).toBe(true);
  });

  it('detects the Android Apple cancel error message', () => {
    expect(isCancelledError({ message: 'E_SIGNIN_CANCELLED_ERROR' })).toBe(true);
  });

  it('returns false for an unrelated error', () => {
    expect(isCancelledError({ code: 500, message: 'server error' })).toBe(false);
  });

  it('returns false for non-object input', () => {
    expect(isCancelledError(null)).toBe(false);
    expect(isCancelledError('cancelled')).toBe(false);
    expect(isCancelledError(undefined)).toBe(false);
  });
});
