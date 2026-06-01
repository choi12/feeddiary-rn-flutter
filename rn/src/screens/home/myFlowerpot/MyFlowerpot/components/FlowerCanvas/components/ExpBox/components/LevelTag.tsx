import React from 'react';
import { StyleSheet, View } from 'react-native';
import { Image as FastImage } from 'expo-image';

import { LevelBox } from '@/assets/images';
import Text from '@/components/common/Text';
import { COLORS } from '@/constants';
import useFlowerpotStats from '@/screens/home/myFlowerpot/MyFlowerpot/hooks/useFlowerpotStats';

function LevelTag() {
  const { level, isMaxLevel } = useFlowerpotStats();

  return (
    <View style={styles.levelBox}>
      <FastImage source={LevelBox} style={styles.levelBoxImage} contentFit="contain" />
      <Text style={[styles.levelText, isMaxLevel && styles.maxLevelText]}>Lv.{!isMaxLevel ? level : ' Max'}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  levelBox: {
    position: 'absolute',
    top: -18,
    alignItems: 'center',
    justifyContent: 'center',
    height: 25,
  },
  levelBoxImage: {
    width: 50,
    height: '100%',
    position: 'absolute',
    opacity: 0.9,
  },
  levelText: {
    color: COLORS.GRAYSCALE.WHITE,
    fontSize: 13,
    marginBottom: 4,
  },
  maxLevelText: {
    fontSize: 12,
  },
});

export default LevelTag;
