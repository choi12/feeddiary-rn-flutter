import React from 'react';
import { StyleSheet, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import LevelTag from './components/LevelTag';
import ProgressBar from './components/ProgressBar';
import ProgressBarCircle from './components/ProgressBarCircle';

const BASE_TOP_OFFSET = 45;

function ExpBox() {
  const { top: safeAreaTopInset } = useSafeAreaInsets();
  const topOffset = BASE_TOP_OFFSET + safeAreaTopInset;

  return (
    <View style={[styles.expBox, { top: topOffset }]}>
      <LevelTag />
      <ProgressBar />
      <ProgressBarCircle />
    </View>
  );
}

const styles = StyleSheet.create({
  expBox: {
    position: 'absolute',
    width: '75%',
    alignSelf: 'center',
    height: 42,
    justifyContent: 'center',
    alignItems: 'center',
  },
});

export default ExpBox;
