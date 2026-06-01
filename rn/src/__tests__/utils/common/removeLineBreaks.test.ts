// removeLineBreaks 유틸 테스트
import { removeLineBreaks } from '@/utils/common/removeLineBreaks';

describe('removeLineBreaks', () => {
  it('replaces a single newline with a space', () => {
    expect(removeLineBreaks('a\nb')).toBe('a b');
  });

  it('replaces every newline in multi-line text', () => {
    expect(removeLineBreaks('a\nb\nc')).toBe('a b c');
  });

  it('returns text without newlines unchanged', () => {
    expect(removeLineBreaks('no breaks')).toBe('no breaks');
  });
});
