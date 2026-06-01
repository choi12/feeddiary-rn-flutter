import { formatAPIError } from '@/api/formatAPIError';
import { APIError, BaseError, UnauthorizedError } from '@/types/errors';

describe('formatAPIError', () => {
  it('prepends the operation name to an Error message and rethrows the same class', () => {
    const err = new UnauthorizedError();
    expect(() => formatAPIError(err, '로그인')).toThrow(UnauthorizedError);
    try {
      formatAPIError(new UnauthorizedError(), '로그인');
    } catch (e) {
      expect(e).toBeInstanceOf(UnauthorizedError);
      expect((e as Error).message.startsWith('[로그인]')).toBe(true);
    }
  });

  it('preserves BaseError subclasses (statusCode, originalError) when re-thrown', () => {
    const original = new APIError(500, 'kaboom');
    try {
      formatAPIError(original, '편지');
    } catch (e) {
      expect(e).toBeInstanceOf(APIError);
      expect(e).toBeInstanceOf(BaseError);
      expect((e as APIError).statusCode).toBe(500);
      expect((e as Error).message).toBe('[편지] kaboom');
    }
  });

  it('wraps non-Error values as an APIError with operation prefix', () => {
    try {
      formatAPIError({ code: 'WEIRD' }, '미션');
    } catch (e) {
      expect(e).toBeInstanceOf(APIError);
      expect((e as APIError).statusCode).toBe(500);
      expect((e as Error).message.startsWith('[미션]')).toBe(true);
    }
  });

  it('wraps a primitive string as an APIError', () => {
    try {
      formatAPIError('detached', '화분');
    } catch (e) {
      expect(e).toBeInstanceOf(APIError);
      expect((e as Error).message).toBe('[화분] detached');
    }
  });
});
