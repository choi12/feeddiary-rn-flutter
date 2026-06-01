import React from 'react';
import { Pressable, StyleSheet } from 'react-native';

import VectorIcon from '@/components/common/VectorIcon';
import { COLORS, LAYOUT } from '@/constants';
import { Icon } from '@/types/icon';

import { DiaryStateUpdater } from '../../../types';
import StickerImage from '../../StickerImage';

interface StickerProps {
  stickerInfo: Icon;
  selectedStickerName: string;
  setDiaryState: DiaryStateUpdater;
}

function Sticker({ stickerInfo, selectedStickerName, setDiaryState }: StickerProps) {
  const isSelected = selectedStickerName === stickerInfo.name;

  const handleStickerPress = () => {
    setDiaryState({ sticker: stickerInfo.name });
  };

  return (
    <Pressable onPress={handleStickerPress} style={[styles.button, isSelected && styles.buttonSelected]}>
      <StickerImage name={stickerInfo.name} size={47} />
      {isSelected && (
        <VectorIcon
          type="Octicons"
          name="check-circle-fill"
          size={20}
          color={COLORS.CORE.MAIN}
          style={styles.checkIcon}
        />
      )}
    </Pressable>
  );
}

const styles = StyleSheet.create({
  button: {
    width: 60,
    height: 60,
    borderRadius: LAYOUT.BORDER_RADIUS,
    alignItems: 'center',
    justifyContent: 'center',
  },
  buttonSelected: {
    transform: [{ scale: 0.9 }],
  },
  checkIcon: {
    position: 'absolute',
    right: 0,
    bottom: 0,
  },
});

export default Sticker;
