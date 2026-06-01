import React from 'react';
import { StyleSheet, View } from 'react-native';

import Text from '@/components/common/Text';
import VectorIcon from '@/components/common/VectorIcon';

import { VISIBILITY_PRESET } from './data';
import { SIZE_PRESET } from './styles';

interface VisibilityBoxProps {
  size: 'small' | 'large';
  isVisible: boolean;
}

function VisibilityBox({ isVisible, size }: VisibilityBoxProps) {
  const sizePreset = SIZE_PRESET[size];
  const visibilityPreset = VISIBILITY_PRESET[String(isVisible) as keyof typeof VISIBILITY_PRESET];

  return (
    <View style={styles.visibilityBox}>
      <VectorIcon
        type="Ionicons"
        name={visibilityPreset.icon}
        color={visibilityPreset.color}
        size={sizePreset.iconSize}
      />
      <Text style={[styles.visibilityText, { fontSize: sizePreset.fontSize, color: visibilityPreset.color }]}>
        {visibilityPreset.text}
      </Text>
    </View>
  );
}

const styles = StyleSheet.create({
  visibilityBox: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  visibilityText: {
    marginLeft: 4,
  },
});

export default VisibilityBox;
