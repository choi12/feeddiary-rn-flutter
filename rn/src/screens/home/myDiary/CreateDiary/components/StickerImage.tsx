import React from 'react';
import { StyleSheet, ImageRequireSource } from 'react-native';
import { Image as FastImage } from 'expo-image';

import { STICKER_ICONS } from '../data';

interface StickerImageProps {
  name: string;
  size: number;
}

function StickerImage({ name, size }: StickerImageProps) {
  const stickerIndex = STICKER_ICONS.findIndex((icon) => icon.name === name);
  const stickerIcon: ImageRequireSource = STICKER_ICONS[stickerIndex].icon;

  return <FastImage source={stickerIcon} style={[styles.sticker, { width: size }]} />;
}

const styles = StyleSheet.create({
  sticker: {
    aspectRatio: 1,
  },
});

export default StickerImage;
