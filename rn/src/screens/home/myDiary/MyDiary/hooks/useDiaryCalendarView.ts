import { useQuery } from '@tanstack/react-query';
import dayjs from 'dayjs';
import { useEffect, useMemo, useState } from 'react';

import { APIGetMonthlyDiaries, APIGetMonthlyDiariesParams } from '@/api/diary/APIGetMonthlyDiaries';
import { QUERY_KEYS } from '@/constants';
import useCalendar from '@/hooks/features/calendar/useCalendar';
import { CalendarDay, Day } from '@/types/calendar';
import { INDEPENDENT_QUERY_CONFIG } from '@/utils/config/query';

import { CalendarListProps } from '../components/CalendarList';

function useDiaryCalendarView(): CalendarListProps {
  const [selectedDate, setSelectedDate] = useState<CalendarDay>(dayjs());
  const [selectedMonth, setSelectedMonth] = useState<Day>(dayjs());

  const {
    data: monthlyDiaries,
    refetch,
    isLoading,
    isError,
  } = useQuery({
    ...INDEPENDENT_QUERY_CONFIG,
    queryKey: [QUERY_KEYS.MONTHLY_DIARIES],
    queryFn: () => {
      const params: APIGetMonthlyDiariesParams = {
        month: dayjs(selectedMonth).format('YYYY-MM'),
      };
      return APIGetMonthlyDiaries(params);
    },
    enabled: !!selectedMonth,
  });

  const dailyDiaries = useMemo(
    () =>
      monthlyDiaries && monthlyDiaries.length > 0
        ? monthlyDiaries.filter((dailyDiary) => dayjs(dailyDiary.createdAt).isSame(selectedDate, 'day'))
        : [],
    [monthlyDiaries, selectedDate],
  );

  useEffect(() => {
    refetch();
  }, [selectedMonth, refetch]);

  // 월별 데이터 로드 시 첫 번째 일기의 날짜 자동 선택
  useEffect(() => {
    if (monthlyDiaries && monthlyDiaries.length > 0) {
      setSelectedDate(dayjs(monthlyDiaries[0].createdAt));
    }
  }, [monthlyDiaries]);

  const { calendarDays } = useCalendar({ date: selectedMonth });

  return {
    monthlyDiaries: monthlyDiaries ?? [],
    refetch,
    dailyDiaries,
    calendarDays,
    selectedMonth,
    setSelectedMonth,
    selectedDate,
    setSelectedDate,
    isLoading,
    isError,
  };
}

export default useDiaryCalendarView;
