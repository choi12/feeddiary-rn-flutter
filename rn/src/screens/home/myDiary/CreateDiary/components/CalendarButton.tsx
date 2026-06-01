import dayjs from 'dayjs';
import React from 'react';
import { Pressable, StyleSheet } from 'react-native';

import Text from '@/components/common/Text';
import VectorIcon from '@/components/common/VectorIcon';
import { COLORS } from '@/constants';
import { Day } from '@/types/calendar';

interface CalendarButtonProps {
  selectedDate: Day;
  onPress: () => void;
}

function CalendarButton({ selectedDate, onPress }: CalendarButtonProps) {
  return (
    <Pressable
      onPress={onPress}
      style={styles.calendarButton}
      accessibilityRole="button"
      accessibilityLabel={`날짜 선택, 현재 ${dayjs(selectedDate).format('YYYY년 M월 D일')}`}
    >
      <VectorIcon type="Entypo" name="calendar" size={14} color={COLORS.CORE.MAIN} />
      <Text style={styles.calendarButtonText}>{dayjs(selectedDate).format('YYYY년 M월 D일')}</Text>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  calendarButton: {
    alignItems: 'center',
    justifyContent: 'center',
    flexDirection: 'row',
    gap: 4,
    borderRadius: 5,
    borderColor: COLORS.CORE.INPUT,
    height: '70%',
    paddingHorizontal: 10,
    marginRight: -10,
  },
  calendarButtonText: {
    fontSize: 13,
    color: COLORS.CORE.MAIN,
    letterSpacing: -0.3,
  },
});

export default CalendarButton;
