// 앱 최초 진입 화면 — 버전 체크/자동 로그인 분기를 수행하는 스플래시성 화면
import React from 'react';
import { StyleSheet, View } from 'react-native';
import { Image as FastImage } from 'expo-image';

import { Logo } from '@/assets/images';
import Text from '@/components/common/Text';
import VectorIcon from '@/components/common/VectorIcon';
import { COLORS, LAYOUT, TEXT } from '@/constants';

import useAppUpdate from './hooks/useAppUpdate';

function Update() {
  useAppUpdate();

  return (
    <View style={styles.container}>
      <View style={styles.logoBox}>
        <FastImage source={Logo} style={styles.logoImage} />
      </View>
      <View style={styles.notiBox}>
        <VectorIcon type="Feather" name="alert-circle" size={15} color={COLORS.CORE.MAIN} />
        <Text style={styles.notiText}>{TEXT.UPDATE.CHECKING_VERSION}</Text>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: COLORS.GRAYSCALE.WHITE,
    padding: LAYOUT.PADDING,
  },
  logoBox: {
    marginBottom: 50,
  },
  logoImage: {
    aspectRatio: 3.35 / 1,
    height: 37,
  },
  notiBox: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 5,
    marginBottom: 15,
  },
  notiText: {
    color: COLORS.CORE.MAIN,
    fontSize: 13,
  },
});

export default Update;
