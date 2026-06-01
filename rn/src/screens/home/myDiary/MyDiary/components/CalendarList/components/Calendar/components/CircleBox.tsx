import React from 'react';
import { StyleSheet, View } from 'react-native';

import { COLORS } from '@/constants';

const CIRCLE_ARRAY = Array(10).fill(null);

function CircleBox() {
  return (
    <View style={styles.circleBox}>
      {CIRCLE_ARRAY.map((_, index) => (
        <View key={index} style={styles.circle} />
      ))}
    </View>
  );
}

const styles = StyleSheet.create({
  circleBox: {
    flexDirection: 'row',
    gap: 20,
    paddingBottom: 15,
  },
  circle: {
    width: 12,
    height: 12,
    borderRadius: 6,
    backgroundColor: COLORS.GRAYSCALE.WHITE_GRAY,
  },
});

export default CircleBox;
