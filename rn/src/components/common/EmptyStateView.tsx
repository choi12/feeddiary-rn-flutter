import React from 'react';
import { StyleSheet, View, useWindowDimensions } from 'react-native';
import { Image as FastImage } from 'expo-image';

import { Lemony3PreviewGrayscale } from '@/assets/images';
import { COLORS } from '@/constants';

import Text from './Text';

interface EmptyStateViewProps {
  message: string;
}

function EmptyStateView({ message }: EmptyStateViewProps) {
  const { height } = useWindowDimensions();

  return (
    <View
      style={[
        styles.container,
        { height: height / 1.5 }, // 컨텐츠의 수직 위치를 화면 정중앙보다 살짝 위로 배치
      ]}
    >
      <FastImage source={Lemony3PreviewGrayscale} style={styles.image} contentFit="contain" />
      <Text style={styles.text}>{message}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    alignItems: 'center',
    justifyContent: 'center',
    gap: 10,
  },
  image: {
    width: 35,
    height: 35,
    opacity: 0.7,
  },
  text: {
    fontSize: 12,
    color: COLORS.GRAYSCALE.LIGHT_GRAY,
  },
});

export default EmptyStateView;
