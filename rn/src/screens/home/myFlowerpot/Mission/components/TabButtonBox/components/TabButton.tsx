import React from 'react';
import { Pressable, StyleSheet } from 'react-native';

import Text from '@/components/common/Text';
import { COLORS } from '@/constants';

interface TabButtonProps {
  label: string;
  count: number;
  isActive: boolean;
  onPress: () => void;
}

function TabButton({ label, count, isActive, onPress }: TabButtonProps) {
  const isDisabled = count < 1;

  return (
    <Pressable onPress={onPress} disabled={isDisabled} style={[styles.tabButton, isActive && styles.activeTabButton]}>
      <Text style={[styles.tabButtonText, isActive && styles.activeTabButtonText]}>
        {label} <Text style={[styles.countText, isDisabled && styles.disabledCountText]}>{count}</Text>
      </Text>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  tabButton: {
    flex: 1,
    height: 42,
    backgroundColor: COLORS.GRAYSCALE.SILVER_GRAY,
    borderRadius: 10,
    alignItems: 'center',
    justifyContent: 'center',
  },
  activeTabButton: { backgroundColor: COLORS.GRAYSCALE.SLATE_GRAY },
  tabButtonText: {
    fontSize: 15,
    color: COLORS.GRAYSCALE.MEDIUM_GRAY,
  },
  activeTabButtonText: { color: COLORS.GRAYSCALE.WHITE },
  countText: {
    color: COLORS.CORE.MAIN,
    fontSize: 16,
  },
  disabledCountText: { color: COLORS.GRAYSCALE.LIGHT_GRAY },
});

export default TabButton;
