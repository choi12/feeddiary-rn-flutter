import dayjs from 'dayjs';
import { useMemo } from 'react';

import { CalendarDays, Day } from '@/types/calendar';

interface UseCalendarProps {
  date: Day;
}
/**
 * 기준 날짜를 받아 월간 달력 데이터 생성
 * - [6주][7일] 형태의 2차원 배열 반환
 * - 이전/다음 달의 날짜는 null로 채움
 */
function useCalendar({ date }: UseCalendarProps) {
  const calendarDays: CalendarDays = useMemo(() => {
    // 1. 지난 달 날짜 채우기
    const firstWeekdayOfMonth = date.startOf('month').day(); // 이번 달의 시작 요일(0: 일요일 ~ 6: 토요일)
    const prevMonthDays = Array(firstWeekdayOfMonth).fill(null); // 지난 달의 날짜만큼 null로 채움

    // 2. 이번 달 날짜 생성
    const lastDateOfMonth = date.endOf('month').date();
    const currentMonth = date.format('YYYY-MM');
    // 이번 달의 모든 날짜를 Dayjs 객체로 생성
    const currentMonthDays = Array.from({ length: lastDateOfMonth }, (_, index) => {
      const day = index + 1;
      return dayjs(`${currentMonth}-${day}`);
    });

    // 3. 다음 달 날짜 채우기
    const lastWeekdayOfMonth = date.endOf('month').day(); // 이번 달 마지막 날의 요일
    // 마지막 주 남은 칸을 null로 채움(7 - (마지막 요일 + 1))
    const nextMonthDays = Array(7 - (lastWeekdayOfMonth + 1)).fill(null);

    // 4. 전체 배열 생성
    const allDays = [...prevMonthDays, ...currentMonthDays, ...nextMonthDays];

    // 5. 6주 형태로 데이터 분할
    // 전체 배열을 7일씩 나누어 2차원 배열 생성
    return Array.from({ length: 6 }, (_, index) => allDays.slice(index * 7, (index + 1) * 7));
  }, [date]);

  return { calendarDays };
}

export default useCalendar;
