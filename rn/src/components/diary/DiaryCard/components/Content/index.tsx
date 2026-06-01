import React from 'react';
import { StyleSheet, View } from 'react-native';
import { Image as FastImage } from 'expo-image';

import Text from '@/components/common/Text';
import { COLORS } from '@/constants';

import { useDiaryCardContext } from '../../context/DiaryCardContext';

import { SIZE_PRESET } from './styles';

/**
 * size prop에 따른 레이아웃:
 * - small: 텍스트와 이미지가 가로로 배치
 * - large: 텍스트와 이미지가 세로로 배치
 */
function Content() {
  const { diary, size } = useDiaryCardContext();
  const preset = SIZE_PRESET[size];

  return (
    <View style={[styles.container, preset.container]}>
      <Text
        numberOfLines={preset.text.numberOfLines}
        ellipsizeMode="tail"
        style={[styles.text, { marginVertical: preset.text.marginVertical }]}
      >
        {diary.text}
      </Text>
      {diary.image && (
        <FastImage source={{ uri: diary.image }} style={preset.image} contentFit="cover" />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    alignItems: 'center',
  },
  text: {
    flex: 1,
    color: COLORS.GRAYSCALE.LIGHT_BLACK,
    fontSize: 13,
    lineHeight: 20,
    alignSelf: 'flex-start',
  },
});

export default Content;
