import React from 'react';
import { StyleSheet } from 'react-native';

import VectorIcon from '@/components/common/VectorIcon';
import { COLORS } from '@/constants';

import { useDiaryCardContext } from '../../context/DiaryCardContext';

import { SIZE_PRESET } from './styles';

function PointImage() {
  const { size } = useDiaryCardContext();
  const preset = SIZE_PRESET[size];

  return (
    <VectorIcon
      type="FontAwesome5"
      name="seedling"
      size={preset.iconSize}
      color={COLORS.CORE.MAIN}
      style={[styles.pointIcon, { top: preset.top }]}
    />
  );
}

const styles = StyleSheet.create({
  pointIcon: {
    position: 'absolute',
    left: 15,
  },
});

export default PointImage;
