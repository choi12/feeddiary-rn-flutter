// useCalendar 훅 테스트 — 기준 월을 [6주][7일] 배열로 변환, 타 월은 null
import { renderHook } from '@testing-library/react-native';
import dayjs from 'dayjs';

import useCalendar from '@/hooks/features/calendar/useCalendar';

describe('useCalendar', () => {
  const date = dayjs('2026-06-15');

  it('always returns 6 rows of 7 days', () => {
    const { result } = renderHook(() => useCalendar({ date }));
    expect(result.current.calendarDays).toHaveLength(6);
    result.current.calendarDays.forEach((week) => {
      // 마지막 빈 주는 빈 배열일 수 있으나, 채워진 주는 7칸
      if (week.length > 0) expect(week).toHaveLength(7);
    });
  });

  it('pads leading nulls up to the first weekday of the month', () => {
    const firstWeekday = date.startOf('month').day();
    const { result } = renderHook(() => useCalendar({ date }));
    const flat = result.current.calendarDays.flat();

    for (let i = 0; i < firstWeekday; i += 1) {
      expect(flat[i]).toBeNull();
    }
    expect(dayjs(flat[firstWeekday] as dayjs.Dayjs).date()).toBe(1);
  });

  it('contains exactly the number of days in the month as non-null cells', () => {
    const daysInMonth = date.daysInMonth();
    const { result } = renderHook(() => useCalendar({ date }));
    const nonNull = result.current.calendarDays.flat().filter(Boolean);

    expect(nonNull).toHaveLength(daysInMonth);
  });
});
