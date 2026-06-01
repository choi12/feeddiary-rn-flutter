import React from 'react';
import { StyleSheet, View } from 'react-native';

import { DailyDiaryDTO } from '@/api/diary/types';
import { COLORS } from '@/constants';
import { CalendarDay, CalendarDays, Day } from '@/types/calendar';

import BackgroundImage from './components/BackgroundImage';
import CircleBox from './components/CircleBox';
import MonthSelector from './components/MonthSelector';
import WeekdayBox from './components/WeekdayBox';
import WeekGroup from './components/WeekGroup';

interface CalendarProps {
  calendarDays: CalendarDays;
  selectedMonth: Day;
  monthlyDiaries: DailyDiaryDTO[];
  selectedDate: CalendarDay;
  setSelectedMonth: (date: Day) => void;
  setSelectedDate: (date: CalendarDay) => void;
}

function Calendar({
  calendarDays,
  selectedMonth,
  monthlyDiaries,
  selectedDate,
  setSelectedDate,
  setSelectedMonth,
}: CalendarProps) {
  return (
    <View style={styles.container}>
      <BackgroundImage />
      <CircleBox />
      <MonthSelector selectedMonth={selectedMonth} setSelectedMonth={setSelectedMonth} />
      <WeekdayBox />
      {calendarDays.map((weekdayRow, index) => (
        <WeekGroup
          key={index}
          weekDays={weekdayRow}
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
  container: {
    paddingHorizontal: 20,
    paddingTop: 13,
    paddingBottom: 15,
    backgroundColor: COLORS.GRAYSCALE.WHITE,
    alignItems: 'center',
    justifyContent: 'center',
    borderRightWidth: 2,
    borderBottomWidth: 3,
    borderColor: COLORS.TRANSPARENT.GRAY_87,
  },
});

export default Calendar;
