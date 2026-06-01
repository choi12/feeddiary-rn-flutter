import React from 'react';
import { StyleSheet, View } from 'react-native';

import { MissionDTO } from '@/api/mission/types';
import { COLORS } from '@/constants';

import { useMissionContext } from '../../../../context/MissionContext';

import MissionButton from './components/MissionButton';
import MissionContent from './components/MissionContent';
import MissionIcon from './components/MissionIcon';

interface MissionBoxProps {
  mission: MissionDTO;
}

function MissionBox({ mission }: MissionBoxProps) {
  const { tab, onCompleteMission, isPendingCompleteMission } = useMissionContext();
  const isCompleted = mission.count === mission.maxCount;

  return (
    <View style={styles.missionItemBox}>
      <MissionIcon type={mission.type} />
      <MissionContent type={mission.type} count={mission.count} maxCount={mission.maxCount} />
      <MissionButton
        tab={tab}
        isCompleted={isCompleted}
        onCompleteMission={() => onCompleteMission(mission.idx, mission.type)}
        isPending={isPendingCompleteMission}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  missionItemBox: {
    backgroundColor: COLORS.GRAYSCALE.WHITE,
    borderRadius: 16,
    paddingVertical: 20,
    paddingHorizontal: 12,
    flexDirection: 'row',
    alignItems: 'center',
    gap: 10,
  },
});

export default MissionBox;
