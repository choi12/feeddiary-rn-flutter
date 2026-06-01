import LottieView, { LottieViewProps } from 'lottie-react-native';
import React from 'react';
import { StyleSheet } from 'react-native';
import Animated, { FadeIn, FadeOut } from 'react-native-reanimated';

import { LottieHeart, LottieRain } from '@/assets/lottie';
import { PlantAction } from '@/types/mission';

interface LottieBoxProps {
  type: PlantAction;
}

const ACTION_LOTTIE: Record<PlantAction, LottieViewProps['source']> = {
  watering: LottieRain,
  love: LottieHeart,
};

function LottieBox({ type }: LottieBoxProps) {
  return (
    <Animated.View style={styles.animatedView} entering={FadeIn} exiting={FadeOut}>
      <LottieView source={ACTION_LOTTIE[type]} autoPlay style={styles.lottie} />
    </Animated.View>
  );
}

const styles = StyleSheet.create({
  animatedView: {
    position: 'absolute',
    top: 0,
  },
  lottie: {
    width: 150,
    height: 150,
    transform: [{ translateY: 10 }, { translateX: 5 }],
  },
});

export default LottieBox;
