import { QueryObserverResult } from '@tanstack/react-query';
import React from 'react';
import { StyleSheet, View } from 'react-native';

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
      <DailyDiaryList dailyDiaries={dailyDiaries} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, marginTop: 15, paddingHorizontal: 12, gap: 10 },
});

export default CalendarList;
