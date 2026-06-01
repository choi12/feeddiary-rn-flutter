import dayjs from 'dayjs';
import React from 'react';
import { StyleSheet, View } from 'react-native';

import Text from '@/components/common/Text';
import { COLORS } from '@/constants';

import { useDiaryCardContext } from '../../context/DiaryCardContext';

import { SIZE_PRESET } from './styles';

function DayBox() {
  const { diary, size } = useDiaryCardContext();
  const preset = SIZE_PRESET[size];

  const date = dayjs(diary.createdAt);

  return (
    <View style={[styles.dayBox, { paddingRight: preset.containerPadding, marginRight: preset.containerMargin }]}>
      <Text style={[styles.dayText, { fontSize: preset.dayFontSize }]}>{date.format('DD')}</Text>
      <Text style={[styles.monthText, { fontSize: preset.monthFontSize }]}>{date.format('M월')}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  dayBox: {
    borderRightWidth: 1,
    borderColor: COLORS.GRAYSCALE.WHITE_GRAY,
  },
  dayText: {
    color: COLORS.GRAYSCALE.DARK_GRAY,
  },
  monthText: {
    color: COLORS.GRAYSCALE.GRAY,
  },
});

export default DayBox;
