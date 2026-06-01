import React from 'react';
import { StyleSheet, View } from 'react-native';

import Text from '@/components/common/Text';
import ProfileImageBox from '@/components/profile/ProfileImageBox';
import { COLORS } from '@/constants';
import { NicknameBoxProfile } from '@/types/profile';

import { SIZE_PRESET } from './styles';

interface NicknameBoxProps {
  profile: NicknameBoxProfile;
  size: 'small' | 'large';
}

function NicknameBox({ profile, size }: NicknameBoxProps) {
  return (
    <View style={styles.topBox}>
      <ProfileImageBox size={SIZE_PRESET[size].icon} profile={profile} />
      <Text style={[styles.nicknameText, { fontSize: SIZE_PRESET[size].text }]}>
        <Text style={[styles.nicknameBoldText, { fontSize: SIZE_PRESET[size].boldText }]}>{profile.nickname} </Text>
        님의 일기
      </Text>
    </View>
  );
}

const styles = StyleSheet.create({
  topBox: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
  },
  nicknameText: {
    color: COLORS.GRAYSCALE.LIGHT_BLACK,
    letterSpacing: -0.5,
    marginLeft: 5,
  },
  nicknameBoldText: {
    color: COLORS.GRAYSCALE.BLACK,
  },
});

export default NicknameBox;
