// convertToLowercase 유틸 테스트
import { convertToLowercase } from '@/utils/common/convertCase';

describe('convertToLowercase', () => {
  it('lowercases mixed-case text', () => {
    expect(convertToLowercase('HelloWorld')).toBe('helloworld');
  });

  it('leaves already-lowercase text unchanged', () => {
    expect(convertToLowercase('already')).toBe('already');
  });

  it('returns an empty string as-is', () => {
    expect(convertToLowercase('')).toBe('');
  });
});
