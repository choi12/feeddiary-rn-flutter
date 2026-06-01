import React from 'react';
import { Image, StyleSheet, View } from 'react-native';

import { Apple, Google } from '@/assets/images';
import Text from '@/components/common/Text';
import { COLORS } from '@/constants';
import useUserInfo from '@/hooks/store/useUserInfo';

function AccountBox() {
  const { type, account } = useUserInfo(['type', 'account']) ?? {};
  const isApple = type === 'apple' || type === undefined;

  return (
    <View style={styles.accountBox}>
      <Image
        source={isApple ? Apple : Google}
        style={[styles.accountImage, isApple && { tintColor: COLORS.GRAYSCALE.BLACK }]}
        resizeMode="contain"
      />
      <Text style={styles.accountText}>{account ?? ''}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  accountBox: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  accountImage: {
    width: 14,
    height: 14,
    marginRight: 5,
  },
  accountText: {
    fontSize: 12,
    color: COLORS.GRAYSCALE.DARK_GRAY,
    marginTop: 2,
  },
});

export default AccountBox;
