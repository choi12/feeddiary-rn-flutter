import { useEffect } from 'react';
import {
  cancelAnimation,
  Easing,
  useAnimatedStyle,
  useSharedValue,
  withRepeat,
  withTiming,
} from 'react-native-reanimated';

import { LETTER_CARD_SIZE } from '../components/LetterList/components/LetterCard';

const ANIMATION_CONFIG = {
  even: {
    value: 5,
    duration: 2000,
    easing: Easing.ease,
  },
  odd: {
    value: -5,
    duration: 2500,
    easing: Easing.ease,
  },
} as const;

function useLetterSwingAnimation() {
  const evenRotation = useSharedValue(0);
  const oddRotation = useSharedValue(0);

  const evenAnimatedStyle = useAnimatedStyle(() => ({
    transform: [
      { translateY: -LETTER_CARD_SIZE / 2 },
      { rotate: `${evenRotation.value}deg` },
      { translateY: LETTER_CARD_SIZE / 2 },
    ],
  }));
  const oddAnimatedStyle = useAnimatedStyle(() => ({
    transform: [
      { translateY: -LETTER_CARD_SIZE / 2 },
      { rotate: `${oddRotation.value}deg` },
      { translateY: LETTER_CARD_SIZE / 2 },
    ],
  }));

  useEffect(() => {
    const startAnimation = () => {
      evenRotation.value = withRepeat(
        withTiming(ANIMATION_CONFIG.even.value, {
          duration: ANIMATION_CONFIG.even.duration,
          easing: ANIMATION_CONFIG.even.easing,
        }),
        -1,
        true,
      );
      oddRotation.value = withRepeat(
        withTiming(ANIMATION_CONFIG.odd.value, {
          duration: ANIMATION_CONFIG.odd.duration,
          easing: ANIMATION_CONFIG.odd.easing,
        }),
        -1,
        true,
      );
    };
    startAnimation();

    return () => {
      cancelAnimation(evenRotation);
      cancelAnimation(oddRotation);
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  return { evenAnimatedStyle, oddAnimatedStyle };
}

export default useLetterSwingAnimation;
