import React, { useCallback } from 'react';
import { Pressable, StyleSheet, View } from 'react-native';
import { Image as FastImage } from 'expo-image';

import Text from '@/components/common/Text';
import VectorIcon from '@/components/common/VectorIcon';
import { COLORS, LAYOUT } from '@/constants';
import { delay } from '@/utils/common/delay';

import { CHARACTER_ICONS_FLAT } from '../../CharacterBox/data';

interface CharacterSelectorProps {
  character?: string;
  toggleCharacterPicker: () => void;
  scrollToEnd: () => void;
  isCharacterPickerVisible: boolean;
}

function CharacterSelector({
  character,
  toggleCharacterPicker,
  scrollToEnd,
  isCharacterPickerVisible,
}: CharacterSelectorProps) {
  const characterIndex = CHARACTER_ICONS_FLAT.findIndex((icon) => icon.name === character);
  const characterData = characterIndex !== -1 ? CHARACTER_ICONS_FLAT[characterIndex] : undefined;

  const handleToggleCharacterPicker = useCallback(async () => {
    toggleCharacterPicker();

    await delay(100);
    scrollToEnd();
  }, [toggleCharacterPicker, scrollToEnd]);

  return (
    <View style={styles.rowBox}>
      <View style={styles.titleBox}>
        <VectorIcon type="FontAwesome" name="user" size={12} color={COLORS.GRAYSCALE.LIGHT_BLACK} />
        <Text style={styles.title}>캐릭터</Text>
      </View>
      <Pressable onPress={handleToggleCharacterPicker} style={styles.characterPickerButton}>
        {character && characterIndex !== -1 && characterData ? (
          <View style={styles.characterBox}>
            <FastImage source={characterData.icon} style={styles.characterImage} />
            <Text style={styles.characterNameText}>{`Lovely ${characterData.name}`}</Text>
          </View>
        ) : (
          <Text style={styles.characterNameText}>캐릭터를 선택해 주세요.</Text>
        )}
        <VectorIcon
          type="Ionicons"
          name={!isCharacterPickerVisible ? 'chevron-down' : 'chevron-up'}
          size={18}
          color={COLORS.GRAYSCALE.DARK_GRAY}
        />
      </Pressable>
    </View>
  );
}

const styles = StyleSheet.create({
  rowBox: { flexDirection: 'row', alignItems: 'center', marginBottom: 10 },
  characterImage: {
    width: 35,
    height: 35,
  },
  titleBox: {
    flexDirection: 'row',
    alignItems: 'center',
    width: 65,
  },
  title: { fontSize: 13, color: COLORS.GRAYSCALE.LIGHT_BLACK, marginLeft: 5 },
  characterPickerButton: {
    flex: 1,
    height: LAYOUT.INPUT_HEIGHT,
    alignItems: 'center',
    justifyContent: 'space-between',
    flexDirection: 'row',
    borderWidth: 1,
    borderColor: COLORS.CORE.INPUT,
    borderRadius: LAYOUT.BORDER_RADIUS,
    paddingHorizontal: 25,
  },
  characterBox: { alignItems: 'center', flexDirection: 'row', gap: 10 },
  characterNameText: { fontSize: 13, color: COLORS.GRAYSCALE.LIGHT_BLACK },
});

export default CharacterSelector;
