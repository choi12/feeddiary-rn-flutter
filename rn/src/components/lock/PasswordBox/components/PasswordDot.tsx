import React from 'react';
import { StyleSheet } from 'react-native';
import { Image as FastImage } from 'expo-image';

import { Lemony3Preview, Lemony3PreviewGrayscale } from '@/assets/images';

interface PasswordDotProps {
  isGrayscale?: boolean;
  opacity?: 1 | 0;
}

function PasswordDot({ isGrayscale = false, opacity = 1 }: PasswordDotProps) {
  return (
    <FastImage
      source={isGrayscale ? Lemony3PreviewGrayscale : Lemony3Preview}
      style={[styles.passwordImage, { opacity }]}
      contentFit="contain"
    />
  );
}

const styles = StyleSheet.create({
  passwordImage: { width: 30, height: 30 },
});

export default PasswordDot;
