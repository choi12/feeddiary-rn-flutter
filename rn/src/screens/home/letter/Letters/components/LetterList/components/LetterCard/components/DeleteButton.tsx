import React from 'react';
import { StyleSheet } from 'react-native';
import Animated, { FadeIn } from 'react-native-reanimated';

import AnimatedPressable from '@/components/common/AnimatedPressable';
import VectorIcon from '@/components/common/VectorIcon';
import { COLORS } from '@/constants';

interface DeleteButtonProps {
  onPress: () => void;
}

function DeleteButton({ onPress }: DeleteButtonProps) {
  return (
    <Animated.View entering={FadeIn}>
      <AnimatedPressable
        onPress={onPress}
        style={styles.button}
        accessibilityRole="button"
        accessibilityLabel="편지 삭제"
      >
        <VectorIcon type="Entypo" name="minus" color={COLORS.GRAYSCALE.BLACK} size={17} />
      </AnimatedPressable>
    </Animated.View>
  );
}

const styles = StyleSheet.create({
  button: {
    width: 25,
    aspectRatio: 1,
    borderRadius: 12.5,
    backgroundColor: COLORS.GRAYSCALE.LIGHT_GRAY,
    position: 'absolute',
    top: -100,
    left: 0,
    alignItems: 'center',
    justifyContent: 'center',
  },
});

export default DeleteButton;
