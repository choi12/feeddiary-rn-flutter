// formatDate 유틸 테스트 — 오늘/올해/다른 연도 및 diary 포맷 분기
import { formatDate } from '@/utils/common/formatDate';

describe('formatDate', () => {
  beforeEach(() => {
    jest.useFakeTimers();
    jest.setSystemTime(new Date('2026-06-02T09:30:00'));
  });
  afterEach(() => jest.useRealTimers());

  describe("diary format", () => {
    it('returns "오늘" for today', () => {
      expect(formatDate('2026-06-02 09:30:00', 'diary')).toBe('오늘');
    });

    it('returns "M월 D일" for another day this year', () => {
      expect(formatDate('2026-03-04 09:30:00', 'diary')).toBe('3월 4일');
    });

    it('returns "YYYY년 M월 D일" for another year', () => {
      expect(formatDate('2023-03-04 09:30:00', 'diary')).toBe('2023년 3월 4일');
    });
  });

  describe('default format', () => {
    it('prefixes today with "오늘," and includes the time', () => {
      expect(formatDate('2026-06-02 09:30:00')).toMatch(/^오늘, (오전|오후) 9:30$/);
    });

    it('uses "M월 D일," for another day this year', () => {
      expect(formatDate('2026-03-04 09:30:00')).toMatch(/^3월 4일, (오전|오후) 9:30$/);
    });

    it('returns "YYYY년 M월 D일" for another year', () => {
      expect(formatDate('2023-03-04 09:30:00')).toBe('2023년 3월 4일');
    });
  });

  it('returns the input unchanged when the date is invalid', () => {
    expect(formatDate('not-a-date')).toBe('not-a-date');
    expect(formatDate('not-a-date', 'diary')).toBe('not-a-date');
  });
});
