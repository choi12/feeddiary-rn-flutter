import React from 'react';
import { StyleSheet, View } from 'react-native';
import { Image as FastImage } from 'expo-image';

import { Logo } from '@/assets/images';
import Text from '@/components/common/Text';
import { COLORS } from '@/constants';
import { useStore } from '@/store';

function AlertModalContentBox() {
  const modalContent = useStore((state) => state.alert.content);

  return (
    <View style={styles.topBox}>
      <View style={styles.titleBox}>
        <FastImage source={Logo} style={styles.logoImage} contentFit="contain" />
      </View>
      {modalContent?.image && modalContent.image}
      <Text style={modalContent?.image ? styles.contentTextWithImage : styles.contentText}>
        {modalContent?.message}
      </Text>
    </View>
  );
}

const styles = StyleSheet.create({
  topBox: {
    alignItems: 'center',
    justifyContent: 'center',
    padding: 15,
  },
  titleBox: {
    flexDirection: 'row',
    alignItems: 'center',
    alignSelf: 'flex-start',
  },
  logoImage: {
    aspectRatio: 3.35 / 1,
    height: 14,
  },
  contentText: {
    color: COLORS.GRAYSCALE.BLACK,
    fontSize: 14,
    marginVertical: 20,
    lineHeight: 20,
  },
  contentTextWithImage: {
    color: COLORS.GRAYSCALE.BLACK,
    fontSize: 14,
    marginBottom: 10,
  },
});

export default AlertModalContentBox;
