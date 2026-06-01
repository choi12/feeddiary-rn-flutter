import React from 'react';
import { StyleSheet, View } from 'react-native';
import { Image as FastImage } from 'expo-image';

import Text from '@/components/common/Text';
import { useProfileContext } from '@/context/profile/ProfileContext';

import { NICKNAME_NOTI_PRESET } from './data';

function NotiBox() {
  const { notiType } = useProfileContext();

  if (!notiType) return null;

  return (
    <View style={styles.notiBox}>
      <FastImage
        source={NICKNAME_NOTI_PRESET[notiType].icon}
        style={styles.notiIcon}
        contentFit="contain"
      />
      <Text style={[styles.notiText, { color: NICKNAME_NOTI_PRESET[notiType].color }]}>
        {NICKNAME_NOTI_PRESET[notiType].text}
      </Text>
    </View>
  );
}

const styles = StyleSheet.create({
  notiBox: {
    flexDirection: 'row',
    alignItems: 'center',
    marginTop: 10,
    marginLeft: 55,
  },
  notiIcon: {
    width: 13,
    height: 13,
  },
  notiText: {
    fontSize: 12,
    marginLeft: 5,
  },
});

export default NotiBox;
