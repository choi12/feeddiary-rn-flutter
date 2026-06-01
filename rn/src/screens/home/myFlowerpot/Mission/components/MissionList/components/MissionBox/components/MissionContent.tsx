import React from 'react';
import { StyleSheet, View } from 'react-native';

import Text from '@/components/common/Text';
import { COLORS } from '@/constants';
import { MISSION_PRESET } from '@/screens/home/myFlowerpot/Mission/data';
import { Mission } from '@/types/mission';

interface MissionContentProps {
  type: Mission;
  count: number;
  maxCount: number;
}

function MissionContent({ type, count, maxCount }: MissionContentProps) {
  return (
    <View style={styles.missionTextBox}>
      <Text style={styles.missionTitle}>
        {MISSION_PRESET[type].title}{' '}
        <Text style={styles.missionCountText}>
          [{count}/{maxCount}]
        </Text>
      </Text>
      <Text style={styles.missionContent}>{MISSION_PRESET[type].content}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  missionTextBox: {
    flex: 1,
  },
  missionTitle: {
    color: COLORS.GRAYSCALE.BLACK,
    fontSize: 15,
  },
  missionCountText: {
    color: COLORS.CORE.MAIN,
    fontSize: 14,
    letterSpacing: 1,
  },
  missionContent: {
    color: COLORS.GRAYSCALE.GRAY,
    fontSize: 12,
    marginTop: 4,
  },
});

export default MissionContent;
