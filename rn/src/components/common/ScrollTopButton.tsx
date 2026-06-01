import React from 'react';
import { StyleSheet, TouchableOpacity } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import { COLORS, isAndroid, LAYOUT } from '@/constants';

import VectorIcon from './VectorIcon';

interface ScrollTopButtonProps {
  onPress: () => void;
}

function ScrollTopButton({ onPress }: ScrollTopButtonProps) {
  const { bottom: safeAreaBottomInset } = useSafeAreaInsets();

  return (
    <TouchableOpacity
      onPress={onPress}
      style={[
        styles.button,
        { bottom: isAndroid ? LAYOUT.BOTTOM_TAB_HEIGHT + 10 : LAYOUT.BOTTOM_TAB_HEIGHT + safeAreaBottomInset },
      ]}
      accessibilityRole="button"
      accessibilityLabel="맨 위로"
    >
      <VectorIcon type="AntDesign" name="totop" size={25} color={COLORS.GRAYSCALE.LIGHT_GRAY} style={styles.icon} />
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  button: {
    alignItems: 'center',
    justifyContent: 'center',
    position: 'absolute',
    right: 10,
    padding: 10,
  },
  icon: {
    opacity: 0.8,
  },
});

export default ScrollTopButton;
