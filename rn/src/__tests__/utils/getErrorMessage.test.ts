import { MESSAGE } from '@/constants';
import { getErrorMessage } from '@/utils/error/getErrorMessage';

describe('getErrorMessage', () => {
  it('returns the message from an Error instance', () => {
    expect(getErrorMessage(new Error('boom'))).toBe('boom');
  });

  it('returns the string as-is when passed a string', () => {
    expect(getErrorMessage('plain error')).toBe('plain error');
  });

  it('returns `.message` from a plain object that has one', () => {
    expect(getErrorMessage({ message: 'object error' })).toBe('object error');
  });

  it('JSON-stringifies an unknown object without `.message`', () => {
    expect(getErrorMessage({ code: 42 })).toBe('{"code":42}');
  });

  it('falls back to a system message for nullish input', () => {
    expect(getErrorMessage(null)).toBe(MESSAGE.SYSTEM.TRY_AGAIN);
    expect(getErrorMessage(undefined)).toBe(MESSAGE.SYSTEM.TRY_AGAIN);
  });
});
