import React from 'react';
import { Pressable, StyleSheet, View } from 'react-native';

import VectorIcon from '@/components/common/VectorIcon';
import ProfileImageBox from '@/components/profile/ProfileImageBox';
import { COLORS, LAYOUT } from '@/constants';
import useScreenNavigation from '@/hooks/core/navigation/useScreenNavigation';
import useUserInfo from '@/hooks/store/useUserInfo';
import { Profile } from '@/types/profile';

import AccountBox from './components/AccountBox';
import NicknameBox from './components/NicknameBox';

function UserProfileBox() {
  const navigation = useScreenNavigation();

  const { image, background, character } = useUserInfo(['image', 'background', 'character']) ?? {};
  const profile: Profile = {
    image: image ?? '',
    background: background ?? '',
    character: character ?? '',
  };

  return (
    <Pressable onPress={() => navigation.navigate('UpdateProfile')} style={styles.topBox}>
      <View style={styles.leftBox}>
        <ProfileImageBox size={60} profile={profile} />
        <View style={styles.topBoxTextWrapper}>
          <NicknameBox />
          <AccountBox />
        </View>
      </View>
      <VectorIcon type="Octicons" name="chevron-right" color={COLORS.GRAYSCALE.LIGHT_GRAY} size={25} />
    </Pressable>
  );
}

const styles = StyleSheet.create({
  topBox: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: LAYOUT.PADDING,
    paddingVertical: 30,
    borderBottomWidth: 8,
    borderColor: COLORS.CORE.BACKGROUND,
  },
  leftBox: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  topBoxTextWrapper: {
    marginHorizontal: 10,
  },
});

export default UserProfileBox;
