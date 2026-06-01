import React from 'react';
import { StyleSheet, View } from 'react-native';

import CloseButton from '@/components/common/CustomHeader/components/CloseButton';
import Text from '@/components/common/Text';
import { COLORS, LAYOUT } from '@/constants';

function TitleBox() {
  return (
    <View style={styles.container}>
      <View style={styles.titleSection}>
        <Text style={styles.titleText}>프로필 설정하기</Text>
        <Text style={styles.subTitleText}>프로필 설정을 하면 회원 가입이 완료돼요.</Text>
      </View>
      <CloseButton style={styles.closeButton} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
  },
  titleSection: {
    marginBottom: 40,
  },
  titleText: {
    fontSize: 22,
    color: COLORS.GRAYSCALE.BLACK,
    marginBottom: 7,
  },
  subTitleText: {
    fontSize: 15,
    color: COLORS.GRAYSCALE.DARK_GRAY,
  },
  closeButton: {
    position: 'absolute',
    top: -13,
    right: -LAYOUT.PADDING,
  },
});

export default TitleBox;
