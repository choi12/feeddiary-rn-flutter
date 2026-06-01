import React from 'react';
import { StyleSheet } from 'react-native';
import { Image as FastImage } from 'expo-image';

import { Lemony3PreviewGrayscale } from '@/assets/images';

function BackgroundImage() {
  return (
    <FastImage
      source={Lemony3PreviewGrayscale}
      style={styles.backgroundImage}
      contentFit="contain"
    />
  );
}

const styles = StyleSheet.create({
  backgroundImage: {
    height: '80%',
    aspectRatio: 1,
    position: 'absolute',
    opacity: 0.15,
  },
});

export default BackgroundImage;
