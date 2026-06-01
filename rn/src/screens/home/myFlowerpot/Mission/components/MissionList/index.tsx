import React from 'react';
import { FlatList, ListRenderItem, StyleSheet } from 'react-native';

import { MissionDTO } from '@/api/mission/types';
import ErrorView from '@/components/common/stateView/ErrorView';
import LoadingView from '@/components/common/stateView/LoadingView';

import { useMissionContext } from '../../context/MissionContext';

import MissionBox from './components/MissionBox';
import MissionListHeaderText from './components/MissionListHeaderText';

function MissionList() {
  const { focusedMissions, refetch, isLoading, isError } = useMissionContext();

  const renderMissionBox: ListRenderItem<MissionDTO> = ({ item: mission }) => <MissionBox mission={mission} />;

  if (isLoading) return <LoadingView />;
  if (isError) return <ErrorView reload={refetch} />;

  return (
    <FlatList
      data={focusedMissions}
      keyExtractor={(mission) => String(mission.idx)}
      ListHeaderComponent={<MissionListHeaderText />}
      renderItem={renderMissionBox}
      contentContainerStyle={styles.bottomBox}
      showsVerticalScrollIndicator={false}
      bounces={false}
      overScrollMode="never"
    />
  );
}

const styles = StyleSheet.create({
  bottomBox: {
    marginTop: 20,
    gap: 10,
  },
});

export default MissionList;
