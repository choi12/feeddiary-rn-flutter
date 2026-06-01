import React from 'react';
import { StyleSheet, View } from 'react-native';

import { COLORS } from '@/constants';
import { MISSION_PRESET } from '@/screens/home/myFlowerpot/Mission/data';
import { Mission } from '@/types/mission';

interface MissionIconProps {
  type: Mission;
}

function MissionIcon({ type }: MissionIconProps) {
  return <View style={styles.iconBox}>{MISSION_PRESET[type].icon}</View>;
}

const styles = StyleSheet.create({
  iconBox: {
    width: 42,
    height: 42,
    backgroundColor: COLORS.ACCENT.BEIGE,
    borderRadius: 21,
    borderWidth: 1,
    borderColor: COLORS.ACCENT.LIGHT_BEIGE,
    alignItems: 'center',
    justifyContent: 'center',
  },
});

export default MissionIcon;
