import { useCallback } from 'react';
import {
  Easing,
  runOnJS,
  useAnimatedStyle,
  useSharedValue,
  withTiming,
  WithTimingConfig,
} from 'react-native-reanimated';

const ANIMATION_CONFIG: WithTimingConfig = {
  duration: 300,
  easing: Easing.linear,
};

const DEFAULT_TRANSLATE_Y = 200;

function useModalAnimation() {
  const opacity = useSharedValue(0);
  const translateY = useSharedValue(DEFAULT_TRANSLATE_Y);

  const animationsCompleted = useSharedValue(0);

  const showAnimation = useCallback(() => {
    animationsCompleted.value = 0;

    opacity.value = withTiming(1, ANIMATION_CONFIG);
    translateY.value = withTiming(0, ANIMATION_CONFIG);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const hideAnimation = useCallback(() => {
    return new Promise<void>((resolve) => {
      // opacity와 translateY 두 개의 애니메이션이 모두 완료되었을 때 Promise를 resolve
      const checkAnimationComplete = (finished: boolean | undefined) => {
        'worklet';
        if (finished) {
          animationsCompleted.value += 1;
          if (animationsCompleted.value === 2) {
            runOnJS(resolve)();
          }
        }
      };
      animationsCompleted.value = 0;
      opacity.value = withTiming(0, ANIMATION_CONFIG, checkAnimationComplete);
      translateY.value = withTiming(DEFAULT_TRANSLATE_Y, ANIMATION_CONFIG, checkAnimationComplete);
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const animatedOpacityStyle = useAnimatedStyle(() => ({
    opacity: opacity.value,
  }));

  const animatedTranslateYStyle = useAnimatedStyle(() => ({
    transform: [{ translateY: translateY.value }],
  }));

  return {
    animatedOpacityStyle,
    animatedTranslateYStyle,
    showAnimation,
    hideAnimation,
  };
}

export default useModalAnimation;
