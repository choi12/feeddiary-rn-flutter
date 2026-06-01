import React from 'react';
import { StyleSheet, View } from 'react-native';
import { Image as FastImage } from 'expo-image';

import { LemonyMain, Logo, Sun, Watering } from '@/assets/images';

function CharacterCanvas() {
  return (
    <View style={styles.topBox}>
      <FastImage source={Logo} style={styles.logoImage} contentFit="contain" />
      <FastImage source={LemonyMain} style={styles.flowerpotImage} contentFit="contain" />
      <FastImage source={Sun} style={styles.sunImage} contentFit="contain" />
      <FastImage source={Watering} style={styles.wateringImage} contentFit="contain" />
    </View>
  );
}

const styles = StyleSheet.create({
  topBox: { flex: 1.4, alignItems: 'center', position: 'relative', zIndex: 1 },
  logoImage: { aspectRatio: 3.35 / 1, height: 50, position: 'absolute', bottom: 290 },
  flowerpotImage: { aspectRatio: 0.59 / 1, position: 'absolute', bottom: -20, height: 180, overflow: 'visible' },
  sunImage: { position: 'absolute', left: 20, bottom: 130, width: 70, height: 70 },
  wateringImage: { aspectRatio: 1.11 / 1, position: 'absolute', right: 15, bottom: 140, height: 120 },
});

export default CharacterCanvas;
