import React from 'react';
import { StyleSheet, View } from 'react-native';

import { DailyDiaryDTO } from '@/api/diary/types';
import { CalendarDay, Day } from '@/types/calendar';

import DayButton from './components/DayButton';

interface WeekGroupProps {
  weekDays: CalendarDay[];
  monthlyDiaries: DailyDiaryDTO[];
  selectedDate: CalendarDay;
  setSelectedMonth: (date: Day) => void;
  setSelectedDate: (date: CalendarDay) => void;
}
function WeekGroup({ weekDays, monthlyDiaries, selectedDate, setSelectedDate, setSelectedMonth }: WeekGroupProps) {
  return (
    <View style={styles.container}>
      {weekDays.map((weekday, weekdayIndex) => (
        <DayButton
          key={weekdayIndex}
          currentDate={weekday}
          weekdayIndex={weekdayIndex}
          monthlyDiaries={monthlyDiaries}
          selectedDate={selectedDate}
          setSelectedDate={setSelectedDate}
          setSelectedMonth={setSelectedMonth}
        />
      ))}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flexDirection: 'row', justifyContent: 'center' },
});

export default WeekGroup;
