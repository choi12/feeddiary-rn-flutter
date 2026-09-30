// 내 일기 달력 뷰 훅 — 월별 일기 조회·선택 날짜 필터링과 달력 셀 데이터 구성
import { keepPreviousData, useQuery } from '@tanstack/react-query';
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
  const month = dayjs(selectedMonth).format('YYYY-MM');

  const {
    data: monthlyDiaries,
    refetch,
    isLoading,
    isError,
    isPlaceholderData,
  } = useQuery({
    ...INDEPENDENT_QUERY_CONFIG,
    queryKey: [QUERY_KEYS.MONTHLY_DIARIES, month],
    queryFn: () => {
      const params: APIGetMonthlyDiariesParams = { month };
      return APIGetMonthlyDiaries(params);
    },
    enabled: !!selectedMonth,
    // 새 달 첫 조회 동안 달력(월 선택기 포함)이 로딩 화면으로 바뀌지 않도록 이전 달 데이터를 유지.
    // 달력 칸은 날짜 정확 일치로 표시하고 다른 달 칸은 null 이라, 이전 달 데이터는 새 달 칸에 표시될 수 없다.
    placeholderData: keepPreviousData,
  });

  const dailyDiaries = useMemo(
    () =>
      !isPlaceholderData && monthlyDiaries && monthlyDiaries.length > 0
        ? monthlyDiaries.filter((dailyDiary) => dayjs(dailyDiary.createdAt).isSame(selectedDate, 'day'))
        : [],
    [monthlyDiaries, selectedDate, isPlaceholderData],
  );

  // 월별 데이터 로드 시 첫 번째 일기의 날짜 자동 선택(이전 달 placeholder 로는 선택하지 않음)
  useEffect(() => {
    if (!isPlaceholderData && monthlyDiaries && monthlyDiaries.length > 0) {
      setSelectedDate(dayjs(monthlyDiaries[0].createdAt));
    }
  }, [monthlyDiaries, isPlaceholderData]);

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
