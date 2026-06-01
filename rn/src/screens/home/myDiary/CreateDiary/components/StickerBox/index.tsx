import React, { useEffect, useRef } from 'react';
import { StyleSheet, ScrollView, View } from 'react-native';

import ScrollContainer from '@/components/common/ScrollContainer';
import Text from '@/components/common/Text';
import { COLORS, LAYOUT } from '@/constants';

import { STICKER_ICONS } from '../../data';
import { DiaryStateUpdater } from '../../types';

import Sticker from './components/Sticker';

interface StickerBoxProps {
  selectedStickerName: string;
  setDiaryState: DiaryStateUpdater;
}

const STICKER_LIST_LAYOUT = {
  ITEM_WIDTH: 60,
  ITEM_GAP: 7,
  SCROLL_OFFSET: 3,
  VISIBLE_ITEMS: 5,
} as const;

function StickerBox({ selectedStickerName, setDiaryState }: StickerBoxProps) {
  const scrollviewRef = useRef<ScrollView>(null);
  const stickerIndex = STICKER_ICONS.findIndex((icon) => icon.name === selectedStickerName);

  useEffect(() => {
    const scrollStickerToCenter = () => {
      if (scrollviewRef.current && stickerIndex !== -1) {
        const scrollPosition =
          (stickerIndex + STICKER_LIST_LAYOUT.SCROLL_OFFSET - STICKER_LIST_LAYOUT.VISIBLE_ITEMS) *
            STICKER_LIST_LAYOUT.ITEM_WIDTH +
          stickerIndex * STICKER_LIST_LAYOUT.ITEM_GAP;

        scrollviewRef.current.scrollTo({ x: scrollPosition, y: 0, animated: true });
      }
    };

    scrollStickerToCenter();
  }, [stickerIndex]);

  return (
    <View style={styles.stickerBox}>
      <Text style={styles.sectionTitleText}>오늘 하루 어땠나요? :D</Text>
      <ScrollContainer ref={scrollviewRef} horizontal contentContainerStyle={styles.weatherBox}>
        {STICKER_ICONS.map((icon) => (
          <Sticker
            key={icon.name}
            stickerInfo={icon}
            selectedStickerName={selectedStickerName}
            setDiaryState={setDiaryState}
          />
        ))}
      </ScrollContainer>
    </View>
  );
}

const styles = StyleSheet.create({
  stickerBox: {
    marginBottom: 12,
  },
  sectionTitleText: {
    fontSize: 14,
    color: COLORS.GRAYSCALE.LIGHT_BLACK,
    margin: LAYOUT.PADDING,
    marginBottom: 10,
  },
  weatherBox: {
    paddingHorizontal: LAYOUT.PADDING,
    gap: 7,
  },
});

export default StickerBox;
