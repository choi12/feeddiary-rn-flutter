import React from 'react';
import { StyleSheet, TouchableOpacity, View } from 'react-native';
import { Image as FastImage } from 'expo-image';

import { COLORS, LAYOUT } from '@/constants';

import { CHARACTER_ICONS } from './data';

interface CharacterBoxProps {
  character?: string;
  onSetCharacter: (character?: string) => void;
}

function CharacterBox({ character, onSetCharacter }: CharacterBoxProps) {
  return (
    <View style={styles.container}>
      {CHARACTER_ICONS.map((characterRow, rowIndex) => (
        <View key={rowIndex} style={styles.imageBox}>
          {characterRow.map(({ name, icon }) => (
            <TouchableOpacity
              key={name}
              onPress={() => onSetCharacter(name)}
              style={[styles.button, name === character && styles.buttonSelected]}
            >
              <FastImage source={icon} style={styles.image} />
            </TouchableOpacity>
          ))}
        </View>
      ))}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    width: '100%',
    gap: 5,
    padding: 10,
    backgroundColor: COLORS.GRAYSCALE.WHITE,
    borderWidth: 1,
    borderColor: COLORS.GRAYSCALE.WHITE_GRAY,
    borderRadius: LAYOUT.BORDER_RADIUS,
  },
  imageBox: {
    width: '100%',
    flexDirection: 'row',
    gap: 5,
  },
  button: {
    flex: 1,
    aspectRatio: 1,
    borderWidth: 2,
    borderRadius: 10,
    padding: 5,
    borderColor: 'transparent',
  },
  buttonSelected: { borderColor: COLORS.GRAYSCALE.WHITE_GRAY },
  image: {
    width: '100%',
    height: '100%',
  },
});

export default CharacterBox;
