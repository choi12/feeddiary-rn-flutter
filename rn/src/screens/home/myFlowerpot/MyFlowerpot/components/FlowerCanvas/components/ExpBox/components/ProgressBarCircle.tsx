import React from 'react';
import { Platform, StyleSheet, Text, View } from 'react-native';
import { Image as FastImage } from 'expo-image';

import { Lemony2Preview, Lemony3Preview } from '@/assets/images';
import { COLORS } from '@/constants';
import useFlowerpotStats from '@/screens/home/myFlowerpot/MyFlowerpot/hooks/useFlowerpotStats';

function ProgressBarCircle() {
  const { level, isMaxLevel } = useFlowerpotStats();

  return (
    <View style={[styles.progressBarCircle, shadowStyle]}>
      {isMaxLevel ? (
        <Text style={styles.maxText}>Max</Text>
      ) : (
        <FastImage
          source={level === 1 ? Lemony2Preview : Lemony3Preview}
          style={styles.progressBarCircleImage}
          contentFit="contain"
        />
      )}
    </View>
  );
}

const shadowStyle = Platform.select({
  android: {
    elevation: 3,
  },
  ios: {
    shadowColor: COLORS.GRAYSCALE.GRAY,
    shadowOpacity: 0.15,
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowRadius: 4,
  },
});

const styles = StyleSheet.create({
  progressBarCircle: {
    alignItems: 'center',
    justifyContent: 'center',
    width: 42,
    height: 42,
    borderRadius: 21,
    backgroundColor: COLORS.ACCENT.SKYBLUE,
    borderWidth: 1,
    borderColor: COLORS.TRANSPARENT.WHITE_70,
    position: 'absolute',
    right: 0,
  },
  progressBarCircleImage: {
    width: '70%',
    height: '70%',
  },
  maxText: { fontSize: 10, color: COLORS.GRAYSCALE.WHITE },
});

export default ProgressBarCircle;
