import LottieView from 'lottie-react-native';
import React from 'react';
import { StyleSheet } from 'react-native';
import { Image as FastImage } from 'expo-image';
import Animated, { FadeIn } from 'react-native-reanimated';

import { Lemony3New } from '@/assets/images';
import { LottieHeart } from '@/assets/lottie';

function ThirdLemony() {
  return (
    <Animated.View entering={FadeIn.duration(300)} style={[styles.lemonyImageBox]}>
      <LottieView source={LottieHeart} autoPlay style={styles.heartLottie} />
      <FastImage source={Lemony3New} style={styles.lemonyImage} contentFit="contain" />
    </Animated.View>
  );
}

const styles = StyleSheet.create({
  lemonyImageBox: {
    height: 220,
    width: 180,
    alignItems: 'center',
    justifyContent: 'flex-end',
  },
  lemonyImage: {
    width: 40,
    height: 70,
  },
  heartLottie: {
    width: 90,
    height: 210,
    position: 'absolute',
    bottom: -50,
    opacity: 0.9,
  },
});

export default ThirdLemony;
