import { CalendarModal } from '@choi12/rn-basic-calendar';
import dayjs from 'dayjs';
import React from 'react';
import { StyleSheet } from 'react-native';

import { COLORS, FONTS } from '@/constants';
import { Day } from '@/types/calendar';

import { DiaryStateUpdater } from '../types';

interface DatePickerProps {
  isVisible: boolean;
  selectedDate: Day;
  setDiaryState: DiaryStateUpdater;
  onClose: () => void;
}

function DatePicker({ isVisible, selectedDate, setDiaryState, onClose }: DatePickerProps) {
  const today = dayjs().endOf('day');

  const handleDayPress = (day: Day) => {
    setDiaryState({ date: day });
    onClose();
  };

  return (
    <CalendarModal
      isVisible={isVisible}
      onClose={onClose}
      value={selectedDate}
      onChange={handleDayPress}
      defaultValue={selectedDate}
      maxDate={today}
      language="ko"
      styles={{
        monthTextStyle: styles.monthTextStyle,
        weekdayTextStyle: styles.weekdayTextStyle,
        dayTextStyle: styles.dayTextStyle,
        todayLabelStyle: styles.todayLabelStyle,
        arrowStyle: styles.arrowStyle,
      }}
      colors={{ primaryColor: COLORS.CORE.MAIN, textColor: COLORS.GRAYSCALE.DARK_GRAY }}
    />
  );
}

const styles = StyleSheet.create({
  monthTextStyle: { fontFamily: FONTS.DOVEMAYO, fontSize: 16 },
  weekdayTextStyle: { fontFamily: FONTS.DOVEMAYO, fontSize: 12 },
  dayTextStyle: { fontFamily: FONTS.DOVEMAYO, fontSize: 14 },
  todayLabelStyle: { fontFamily: FONTS.DOVEMAYO, fontSize: 8 },
  arrowStyle: { fontFamily: FONTS.DOVEMAYO, fontSize: 18 },
});

export default DatePicker;
