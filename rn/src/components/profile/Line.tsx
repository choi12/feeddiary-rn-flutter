import React from 'react';
import { StyleSheet, View } from 'react-native';

import { COLORS } from '@/constants';

interface LineProps {
  margin: number;
}

function Line({ margin = 40 }: LineProps) {
  return <View style={[styles.line, { marginVertical: margin }]} />;
}

const styles = StyleSheet.create({
  line: {
    width: '100%',
    height: 1,
    backgroundColor: COLORS.GRAYSCALE.WHITE_GRAY,
  },
});

export default Line;
