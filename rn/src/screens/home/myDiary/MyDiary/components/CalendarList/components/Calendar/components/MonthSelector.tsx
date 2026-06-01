import dayjs from 'dayjs';
import React from 'react';
import { Pressable, StyleSheet, View } from 'react-native';

import Text from '@/components/common/Text';
import VectorIcon from '@/components/common/VectorIcon';
import { COLORS } from '@/constants';
import { Day } from '@/types/calendar';

interface MonthSelectorProps {
  selectedMonth: Day;
  setSelectedMonth: (date: Day) => void;
}

function MonthSelector({ selectedMonth, setSelectedMonth }: MonthSelectorProps) {
  const isNextMonthDisabled = dayjs().isSameOrBefore(selectedMonth, 'month');

  const handleMoveToPrevMonth = () => setSelectedMonth(selectedMonth.subtract(1, 'month'));
  const handleMoveToNextMonth = () => setSelectedMonth(selectedMonth.add(1, 'month'));

  return (
    <View style={styles.monthBox}>
      <Pressable
        onPress={handleMoveToPrevMonth}
        style={styles.monthButton}
        accessibilityRole="button"
        accessibilityLabel="이전 달"
      >
        <VectorIcon type="AntDesign" name="caretleft" size={16} color={COLORS.CORE.MAIN} />
      </Pressable>
      <View style={styles.monthTextBox}>
        <Text style={styles.yearText}>{selectedMonth.format('YYYY')}</Text>
        <Text style={styles.monthText}>{selectedMonth.format('M')}</Text>
      </View>
      <Pressable
        disabled={isNextMonthDisabled}
        onPress={handleMoveToNextMonth}
        style={styles.monthButton}
        accessibilityRole="button"
        accessibilityLabel="다음 달"
        accessibilityState={{ disabled: isNextMonthDisabled }}
      >
        <VectorIcon
          type="AntDesign"
          name="caretright"
          size={16}
          color={isNextMonthDisabled ? COLORS.GRAYSCALE.LIGHT_GRAY : COLORS.CORE.MAIN}
        />
      </Pressable>
    </View>
  );
}

const styles = StyleSheet.create({
  monthBox: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  monthButton: {
    paddingVertical: 15,
    paddingHorizontal: 25,
  },
  monthTextBox: {
    alignItems: 'center',
  },
  yearText: {
    marginHorizontal: 20,
    fontSize: 12,
    color: COLORS.GRAYSCALE.GRAY,
  },
  monthText: {
    fontSize: 35,
    color: COLORS.CORE.MAIN,
    marginTop: -7,
  },
});

export default MonthSelector;
