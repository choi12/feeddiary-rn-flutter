import React from 'react';
import { StyleSheet } from 'react-native';
import { Image as FastImage } from 'expo-image';
import Animated, { FadeIn } from 'react-native-reanimated';

import { Lemony1Flowerpot, Lemony1Seed } from '@/assets/images';

import useLemonySeedAnimation from './hooks/useLemonySeedAnimation';

function FirstLemony() {
  const { animatedLemonySeedStyle } = useLemonySeedAnimation();

  return (
    <Animated.View entering={FadeIn.duration(300)} style={[styles.seedLemonyBox]}>
      <FastImage
        source={Lemony1Flowerpot}
        style={styles.seedFlowerpotImage}
        contentFit="contain"
      />
      <Animated.View style={[styles.seedLemonyImageBox, animatedLemonySeedStyle]}>
        <FastImage source={Lemony1Seed} style={styles.seedLemonyImage} contentFit="contain" />
      </Animated.View>
    </Animated.View>
  );
}

const styles = StyleSheet.create({
  seedLemonyBox: {
    width: 180,
    justifyContent: 'center',
    alignItems: 'center',
    paddingBottom: 10,
  },
  seedFlowerpotImage: {
    height: 220,
    width: 180,
  },
  seedLemonyImageBox: { position: 'absolute' },
  seedLemonyImage: {
    width: 30,
    height: 43,
  },
});

export default FirstLemony;
