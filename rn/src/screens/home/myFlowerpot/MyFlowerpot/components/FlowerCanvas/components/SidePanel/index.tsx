import React from 'react';
import { StyleSheet, useWindowDimensions, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import { calculateVerticalCenter } from '@/utils/common/calculateVerticalCenter';

import ActionButton from './components/ActionButton';
import MissionButton from './components/MissionButton';

// 레몬 기준 위로 올리는 값
const VERTICAL_OFFSET = 260;

function SidePanel() {
  const { height } = useWindowDimensions();
  const { bottom } = useSafeAreaInsets();

  const verticalCenter = calculateVerticalCenter(height, bottom);

  return (
    <View style={[styles.container, { top: verticalCenter - VERTICAL_OFFSET }]}>
      <MissionButton />
      <ActionButton type="watering" />
      <ActionButton type="love" />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    padding: 15,
    position: 'absolute',
    left: 0,
    gap: 10,
  },
});

export default SidePanel;
