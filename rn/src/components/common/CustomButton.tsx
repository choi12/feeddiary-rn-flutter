import React from 'react';
import { ActivityIndicator, PressableProps, StyleSheet, View } from 'react-native';
import Animated, { useAnimatedStyle, withTiming } from 'react-native-reanimated';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import { LAYOUT, COLORS, isAndroid } from '@/constants';
import useKeyboardState from '@/hooks/ui/interaction/useKeyboardState';

import AnimatedPressable from './AnimatedPressable';
import Text from './Text';

interface CustomButtonProps extends PressableProps {
  title: string;
  onPress: () => void;
  isAnimated?: boolean;
  disabled?: boolean;
  isLoading?: boolean;
}

function CustomButton({ title, onPress, isAnimated, disabled, isLoading, ...props }: CustomButtonProps) {
  const { bottom } = useSafeAreaInsets();
  const { isKeyboardVisible, keyboardHeight } = useKeyboardState();

  const animatedBoxStyle = useAnimatedStyle(
    () => ({
      paddingHorizontal: withTiming(isKeyboardVisible ? 0 : LAYOUT.PADDING),
      paddingBottom: withTiming(isKeyboardVisible ? (isAndroid ? 0 : keyboardHeight - bottom) : LAYOUT.PADDING),
    }),
    [isKeyboardVisible, keyboardHeight],
  );

  return (
    <Animated.View style={isAnimated ? animatedBoxStyle : undefined}>
      <AnimatedPressable onPress={onPress} disabled={disabled || isLoading} {...props}>
        <View
          style={[
            styles.button,
            (disabled || isLoading) && { backgroundColor: COLORS.CORE.INPUT },
            isAnimated && isKeyboardVisible && styles.buttonNoRadius,
          ]}
        >
          {isLoading ? (
            <ActivityIndicator color={COLORS.GRAYSCALE.WHITE} size="small" />
          ) : (
            <Text style={styles.text}>{title}</Text>
          )}
        </View>
      </AnimatedPressable>
    </Animated.View>
  );
}

const styles = StyleSheet.create({
  button: {
    width: '100%',
    height: LAYOUT.BUTTON_HEIGHT,
    borderRadius: LAYOUT.BORDER_RADIUS,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: COLORS.CORE.MAIN,
  },
  buttonNoRadius: {
    borderRadius: 0,
  },
  text: {
    color: COLORS.GRAYSCALE.WHITE,
    fontSize: 17,
  },
});

export default CustomButton;
