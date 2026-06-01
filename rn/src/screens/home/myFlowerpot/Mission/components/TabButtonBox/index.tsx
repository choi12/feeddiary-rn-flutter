import React from 'react';
import { StyleSheet, View } from 'react-native';

import { useMissionContext } from '../../context/MissionContext';

import TabButton from './components/TabButton';
import { MISSION_TABS } from './data';

function TabButtonBox() {
  const { count, tab, onSetTab, isLoading, isError } = useMissionContext();

  if (isLoading || isError) return null;

  return (
    <View style={styles.topBox}>
      {MISSION_TABS.map(({ type, label, value }) => (
        <TabButton
          key={type}
          label={label}
          count={count[value]}
          isActive={tab === value}
          onPress={() => onSetTab(value)}
        />
      ))}
    </View>
  );
}

const styles = StyleSheet.create({
  topBox: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 10,
  },
});

export default TabButtonBox;
