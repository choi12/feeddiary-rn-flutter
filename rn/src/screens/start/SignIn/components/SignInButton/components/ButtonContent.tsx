import React from 'react';
import { StyleSheet } from 'react-native';
import { Image as FastImage } from 'expo-image';

import Text from '@/components/common/Text';
import { COLORS } from '@/constants';
import { SignInType } from '@/types/auth';

import { SIGN_IN_COLOR, SIGN_IN_ICON, SIGN_IN_LABEL } from '../data';

interface ButtonContentProps {
  type: SignInType;
}

function ButtonContent({ type }: ButtonContentProps) {
  return (
    <>
      <FastImage
        source={SIGN_IN_ICON[type]}
        style={[styles.icon, type === 'apple' && styles.appleIconAdjustment]}
        contentFit="contain"
      />
      <Text style={[styles.text, { color: SIGN_IN_COLOR[type].text }]}>{SIGN_IN_LABEL[type]}</Text>
    </>
  );
}

const styles = StyleSheet.create({
  icon: {
    width: 21,
    height: 22,
    marginRight: 10,
  },
  appleIconAdjustment: {
    marginBottom: 5,
  },
  text: {
    color: COLORS.GRAYSCALE.LIGHT_BLACK,
    fontSize: 16,
  },
});

export default ButtonContent;
