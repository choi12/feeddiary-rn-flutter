import React from 'react';
import { StyleSheet, View } from 'react-native';
import { Image as FastImage } from 'expo-image';

import { Letter } from '@/assets/images';
import Text from '@/components/common/Text';
import { COLORS, FONTS } from '@/constants';

function LetterHeaderTitleBox() {
  return (
    <View style={styles.headerTitleBox}>
      <Text style={styles.headerText}>나에게 쓰는 편지</Text>
      <FastImage source={Letter} style={styles.headerIcon} contentFit="contain" />
    </View>
  );
}

const styles = StyleSheet.create({
  headerTitleBox: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
  },
  headerText: {
    fontFamily: FONTS.ONGLE,
    fontSize: 24,
    color: COLORS.GRAYSCALE.LIGHT_BLACK,
    letterSpacing: -0.5,
  },
  headerIcon: {
    width: 30,
    height: 30,
    marginLeft: 3,
  },
});

export default LetterHeaderTitleBox;
