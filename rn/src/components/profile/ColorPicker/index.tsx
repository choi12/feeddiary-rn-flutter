import React from 'react';
import { StyleSheet, TouchableOpacity, View } from 'react-native';

import Text from '@/components/common/Text';
import VectorIcon from '@/components/common/VectorIcon';
import { COLORS } from '@/constants';

import { PICKER_COLORS } from './data';

interface ColorPickerProps {
  onSetBackground: (background?: string) => void;
}

function ColorPicker({ onSetBackground }: ColorPickerProps) {
  return (
    <View style={styles.container}>
      <View style={styles.titleBox}>
        <VectorIcon type="MaterialIcons" name="colorize" size={15} color={COLORS.GRAYSCALE.LIGHT_BLACK} />
        <Text style={styles.titleText}>배경색을 선택해 주세요.</Text>
      </View>
      {PICKER_COLORS.map((colorRow, colorRowIndex) => (
        <View key={colorRowIndex} style={styles.pickerBox}>
          {colorRow.map((color) => (
            <TouchableOpacity
              key={color}
              onPress={() => onSetBackground(color)}
              style={[styles.button, { backgroundColor: color }]}
            />
          ))}
        </View>
      ))}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    width: '90%',
    gap: 5,
    padding: 10,
    backgroundColor: COLORS.GRAYSCALE.WHITE,
    borderWidth: 1,
    borderColor: COLORS.GRAYSCALE.WHITE_GRAY,
    borderRadius: 5,
  },
  titleBox: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 3,
    marginBottom: 7,
  },
  titleText: {
    color: COLORS.GRAYSCALE.LIGHT_BLACK,
    fontSize: 13,
  },
  pickerBox: {
    width: '100%',
    flexDirection: 'row',
    gap: 5,
  },
  button: {
    flex: 1,
    aspectRatio: 1,
  },
});

export default ColorPicker;
