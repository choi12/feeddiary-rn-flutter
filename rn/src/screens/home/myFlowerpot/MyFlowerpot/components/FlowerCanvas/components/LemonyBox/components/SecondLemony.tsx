import React from 'react';
import { StyleSheet } from 'react-native';
import Animated, { FadeIn } from 'react-native-reanimated';

import { Lemony2 } from '@/assets/images';

function SecondLemony() {
  return (
    <Animated.Image
      entering={FadeIn.duration(300)}
      source={Lemony2}
      style={[styles.flowerpotLemonyImage]}
      resizeMode="contain"
    />
  );
}

const styles = StyleSheet.create({
  flowerpotLemonyImage: {
    height: 220,
    width: 180,
  },
});

export default SecondLemony;
