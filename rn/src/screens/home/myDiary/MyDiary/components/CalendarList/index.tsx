import { QueryObserverResult } from '@tanstack/react-query';
import React from 'react';
import { StyleSheet, View } from 'react-native';
import { LayoutAnimationConfig } from 'react-native-reanimated';

import { DailyDiaryDTO } from '@/api/diary/types';
import ErrorView from '@/components/common/stateView/ErrorView';
import LoadingView from '@/components/common/stateView/LoadingView';
import { CalendarDay, CalendarDays, Day } from '@/types/calendar';

import Calendar from './components/Calendar';
import DailyDiaryList from './components/DailyDiaryList';

export interface CalendarListProps {
  monthlyDiaries: DailyDiaryDTO[];
  refetch: () => Promise<QueryObserverResult<DailyDiaryDTO[], Error>>;
  dailyDiaries: DailyDiaryDTO[];
  calendarDays: CalendarDays;
  selectedMonth: Day;
  selectedDate: CalendarDay;
  setSelectedMonth: (date: Day) => void;
  setSelectedDate: (date: CalendarDay) => void;
  isLoading: boolean;
  isError: boolean;
}

function CalendarList({
  monthlyDiaries,
  refetch,
  dailyDiaries,
  calendarDays,
  selectedMonth,
  setSelectedMonth,
  setSelectedDate,
  selectedDate,
  isLoading,
  isError,
}: CalendarListProps) {
  if (isLoading) return <LoadingView />;
  if (isError) return <ErrorView reload={refetch} />;

  return (
    <View style={styles.container}>
      <Calendar
        calendarDays={calendarDays}
        selectedMonth={selectedMonth}
        monthlyDiaries={monthlyDiaries}
        selectedDate={selectedDate}
        setSelectedMonth={setSelectedMonth}
        setSelectedDate={setSelectedDate}
      />
      {/* 달이 바뀌면 목록을 새로 그려, 이전 달 카드가 나가는 애니메이션으로 새 달 달력 아래에 잔상을 남기지 않게 한다 */}
      <LayoutAnimationConfig key={selectedMonth.format('YYYY-MM')} skipExiting>
        <DailyDiaryList dailyDiaries={dailyDiaries} />
      </LayoutAnimationConfig>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, marginTop: 15, paddingHorizontal: 12, gap: 10 },
});

export default CalendarList;
