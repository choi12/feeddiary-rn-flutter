import { getFormField, getImageUri, getNumber, getString } from '@/api/mock/helpers';

describe('getFormField', () => {
  it('reads a value from a RN-style FormData with `_parts`', () => {
    const fd = { _parts: [['nickname', '데모유저'], ['idx', 1]] as [string, unknown][] };
    expect(getFormField(fd, 'nickname')).toBe('데모유저');
    expect(getFormField(fd, 'idx')).toBe(1);
    expect(getFormField(fd, 'missing')).toBeUndefined();
  });

  it('falls back to `entries()` when `_parts` is absent', () => {
    const entries: [string, unknown][] = [['key', 'value']];
    const fd = {
      entries: () => entries[Symbol.iterator](),
    };
    expect(getFormField(fd, 'key')).toBe('value');
    expect(getFormField(fd, 'absent')).toBeUndefined();
  });

  it('returns undefined for null/undefined input', () => {
    expect(getFormField(undefined, 'x')).toBeUndefined();
    expect(getFormField(null, 'x')).toBeUndefined();
  });
});

describe('getString', () => {
  it('returns the value when it is a string', () => {
    expect(getString('hello')).toBe('hello');
  });

  it('returns the fallback for non-string input', () => {
    expect(getString(undefined)).toBe('');
    expect(getString(42, 'fallback')).toBe('fallback');
    expect(getString(null, 'x')).toBe('x');
  });
});

describe('getNumber', () => {
  it('coerces numeric strings to numbers', () => {
    expect(getNumber('42')).toBe(42);
    expect(getNumber(7)).toBe(7);
  });

  it('returns fallback for non-finite values', () => {
    expect(getNumber('abc')).toBe(0);
    expect(getNumber(undefined, 99)).toBe(99);
    expect(getNumber(NaN, 5)).toBe(5);
  });
});

describe('getImageUri', () => {
  it('returns the `uri` field from an object', () => {
    expect(getImageUri({ uri: 'file:///x.png' })).toBe('file:///x.png');
  });

  it('returns undefined for primitives or objects without `uri`', () => {
    expect(getImageUri('not-an-object')).toBeUndefined();
    expect(getImageUri(undefined)).toBeUndefined();
    expect(getImageUri({ size: 12 })).toBeUndefined();
  });
});
