import React from 'react';
import { ActivityIndicator, StyleSheet, View } from 'react-native';

import VisibilityController from '@/components/controller/VisibilityController';
import { COLORS } from '@/constants';
import { useStore } from '@/store';

function LoadingBox() {
  const isLoadingBoxVisible = useStore((state) => state.loading.isVisible);

  return (
    <VisibilityController isVisible={isLoadingBoxVisible}>
      <View style={styles.container}>
        <ActivityIndicator color={COLORS.GRAYSCALE.LIGHT_GRAY} size="large" />
      </View>
    </VisibilityController>
  );
}

const styles = StyleSheet.create({
  container: {
    position: 'absolute',
    left: 0,
    right: 0,
    top: 0,
    bottom: 0,
    alignItems: 'center',
    justifyContent: 'center',
  },
});

export default LoadingBox;
