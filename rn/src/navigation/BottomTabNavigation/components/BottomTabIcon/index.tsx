import React from 'react';
import { StyleSheet, View } from 'react-native';

import VectorIcon from '@/components/common/VectorIcon';
import { COLORS } from '@/constants';

import { TabParamList } from '../../types';

import { BOTTOM_TAB_ICON, LETTERS_CONFIG } from './data';

interface BottomTabIconProps {
  focused: boolean;
  name: keyof TabParamList;
}

function BottomTabIcon({ focused, name }: BottomTabIconProps) {
  const isLettersComponent = name === 'Letters';
  return (
    <View style={styles.container}>
      <VectorIcon
        type={isLettersComponent ? LETTERS_CONFIG.type : 'FontAwesome5'}
        name={BOTTOM_TAB_ICON[name]}
        color={focused ? COLORS.CORE.MAIN : COLORS.GRAYSCALE.LIGHT_GRAY}
        size={isLettersComponent ? LETTERS_CONFIG.size : 21}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});

export default BottomTabIcon;
