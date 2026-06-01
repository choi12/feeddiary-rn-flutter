import { useEffect } from 'react';
import {
  cancelAnimation,
  Easing,
  useAnimatedStyle,
  useSharedValue,
  withRepeat,
  withTiming,
} from 'react-native-reanimated';

const ANIMATION_CONFIG = {
  rotation: {
    value: '-2deg',
    duration: 500,
    easing: Easing.ease,
  },
  translateX: {
    value: -30,
    duration: 5000,
    easing: Easing.linear,
  },
} as const;

function useLemonySeedAnimation() {
  const rotation = useSharedValue('2deg');
  const translateX = useSharedValue(30);

  const animatedLemonySeedStyle = useAnimatedStyle(() => ({
    transform: [{ rotate: rotation.value }, { translateX: translateX.value }],
  }));

  useEffect(() => {
    const startSeedMovingAnimation = () => {
      rotation.value = withRepeat(
        withTiming(ANIMATION_CONFIG.rotation.value, {
          duration: ANIMATION_CONFIG.rotation.duration,
          easing: ANIMATION_CONFIG.rotation.easing,
        }),
        -1,
        true,
      );
      translateX.value = withRepeat(
        withTiming(ANIMATION_CONFIG.translateX.value, {
          duration: ANIMATION_CONFIG.translateX.duration,
          easing: ANIMATION_CONFIG.translateX.easing,
        }),
        -1,
        true,
      );
    };
    startSeedMovingAnimation();

    return () => {
      cancelAnimation(rotation);
      cancelAnimation(translateX);
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  return { animatedLemonySeedStyle };
}

export default useLemonySeedAnimation;
