import React, { PropsWithChildren } from 'react';
import { Pressable, PressableProps } from 'react-native';
import Animated, {
  Easing,
  useAnimatedStyle,
  useSharedValue,
  withTiming,
  WithTimingConfig,
} from 'react-native-reanimated';

const ANIMATION_CONFIG: WithTimingConfig = {
  duration: 150,
  easing: Easing.ease,
};

function AnimatedPressable({
  children,
  pressedScale = 0.99,
  pressedOpacity = 0.9,
  ...props
}: PropsWithChildren<PressableProps> & { pressedScale?: number; pressedOpacity?: number }) {
  const scale = useSharedValue(1);
  const opacity = useSharedValue(1);

  const animatedPressableStyle = useAnimatedStyle(
    () => ({
      transform: [{ scale: scale.value }],
      opacity: opacity.value,
    }),
    [],
  );

  const handlePressIn = () => {
    scale.value = withTiming(pressedScale, ANIMATION_CONFIG);
    opacity.value = withTiming(pressedOpacity, ANIMATION_CONFIG);
  };

  const handlePressOut = () => {
    scale.value = withTiming(1, ANIMATION_CONFIG);
    opacity.value = withTiming(1, ANIMATION_CONFIG);
  };

  return (
    <Animated.View style={[animatedPressableStyle]}>
      <Pressable {...props} style={props.style} onPressIn={handlePressIn} onPressOut={handlePressOut}>
        {children}
      </Pressable>
    </Animated.View>
  );
}

export default AnimatedPressable;
