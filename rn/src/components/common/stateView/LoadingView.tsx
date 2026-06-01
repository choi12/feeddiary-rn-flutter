import React from 'react';
import { ActivityIndicator, StyleSheet, View } from 'react-native';

import { COLORS } from '@/constants';

function LoadingView() {
  return (
    <View style={[StyleSheet.absoluteFill, styles.box]}>
      <ActivityIndicator color={COLORS.GRAYSCALE.LIGHT_GRAY} size="large" />
    </View>
  );
}

const styles = StyleSheet.create({
  box: {
    justifyContent: 'center',
    alignItems: 'center',
    zIndex: -1,
  },
});

export default LoadingView;
