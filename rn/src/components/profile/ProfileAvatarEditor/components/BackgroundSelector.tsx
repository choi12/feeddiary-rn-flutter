import React from 'react';
import { Pressable, StyleSheet, View } from 'react-native';

import Text from '@/components/common/Text';
import VectorIcon from '@/components/common/VectorIcon';
import { COLORS, LAYOUT } from '@/constants';

interface BackgroundSelectorProps {
  background?: string;
  onOpenColorPicker: () => void;
}

function BackgroundSelector({ background, onOpenColorPicker }: BackgroundSelectorProps) {
  return (
    <View style={styles.rowBox}>
      <View style={styles.titleBox}>
        <VectorIcon
          type="MaterialCommunityIcons"
          name="format-color-fill"
          size={15}
          color={COLORS.GRAYSCALE.LIGHT_BLACK}
        />
        <Text style={styles.title}>배경</Text>
      </View>
      <Pressable
        onPress={onOpenColorPicker}
        style={[styles.colorPickerButton, { backgroundColor: background ?? COLORS.GRAYSCALE.WHITE }]}
      >
        {!background && (
          <VectorIcon type="MaterialIcons" name="colorize" size={15} color={COLORS.GRAYSCALE.LIGHT_BLACK} />
        )}
      </Pressable>
    </View>
  );
}

const styles = StyleSheet.create({
  rowBox: { flexDirection: 'row', alignItems: 'center', marginBottom: 10 },
  titleBox: {
    flexDirection: 'row',
    alignItems: 'center',
    width: 65,
  },
  title: { fontSize: 13, color: COLORS.GRAYSCALE.LIGHT_BLACK, marginLeft: 5 },
  colorPickerButton: {
    flex: 1,
    height: LAYOUT.INPUT_HEIGHT,
    borderRadius: LAYOUT.BORDER_RADIUS,
    borderWidth: 1,
    borderColor: COLORS.CORE.INPUT,
    alignItems: 'center',
    justifyContent: 'center',
  },
});

export default BackgroundSelector;
