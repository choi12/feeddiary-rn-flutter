import dayjs from 'dayjs';
import React, { useMemo } from 'react';
import { StyleSheet, TouchableOpacity } from 'react-native';
import Animated, { ZoomIn } from 'react-native-reanimated';

import { DailyDiaryDTO } from '@/api/diary/types';
import { Pencil } from '@/assets/images';
import Text from '@/components/common/Text';
import { COLORS } from '@/constants';
import { CalendarDay, Day } from '@/types/calendar';

interface DayButtonProps {
  currentDate: CalendarDay;
  weekdayIndex: number;
  monthlyDiaries: DailyDiaryDTO[];
  selectedDate: CalendarDay;
  setSelectedMonth: (date: Day) => void;
  setSelectedDate: (date: CalendarDay) => void;
}

function DayButton({
  currentDate,
  weekdayIndex,
  monthlyDiaries,
  selectedDate,
  setSelectedMonth,
  setSelectedDate,
}: DayButtonProps) {
  const diaryCount = useMemo(() => {
    if (!currentDate || monthlyDiaries.length < 1) return 0;

    const formattedDay = dayjs(currentDate).format('YYYY-MM-DD');
    return monthlyDiaries.filter((dailyDiary) => dayjs(dailyDiary.createdAt).format('YYYY-MM-DD') === formattedDay)
      .length;
  }, [currentDate, monthlyDiaries]);

  const hasDiary = diaryCount > 0;
  const isSelected = !!currentDate && !!selectedDate && dayjs(currentDate).isSame(selectedDate, 'day');
  const isWeekendDay = weekdayIndex === 0 || weekdayIndex === 6;

  const handleDaySelection = () => {
    if (currentDate) {
      setSelectedDate(currentDate);
      setSelectedMonth(currentDate);
    }
  };

  return (
    <TouchableOpacity
      disabled={!currentDate || !hasDiary}
      onPress={handleDaySelection}
      style={[styles.dayButton, isSelected && { backgroundColor: COLORS.GRAYSCALE.WHITE_GRAY }]}
    >
      {hasDiary ? (
        <Animated.Image source={Pencil} style={styles.marker} resizeMode="contain" entering={ZoomIn.duration(500)} />
      ) : (
        <Text style={[styles.dayButtonText, isWeekendDay && { color: COLORS.CORE.MAIN }]}>
          {currentDate ? dayjs(currentDate).format('D') : ''}
        </Text>
      )}
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  dayButton: {
    flex: 1,
    height: 40,
    borderRadius: 12,
    alignItems: 'center',
    justifyContent: 'center',
  },
  dayButtonText: {
    fontSize: 13,
    color: COLORS.GRAYSCALE.GRAY,
  },
  marker: {
    width: 20,
    height: 20,
  },
});

export default DayButton;
