import React from 'react';
import { StyleSheet, View } from 'react-native';
import { Image as FastImage } from 'expo-image';

import VectorIcon from '@/components/common/VectorIcon';
import { COLORS } from '@/constants';
import { Profile } from '@/types/profile';

import { CHARACTER_ICONS_FLAT } from './CharacterBox/data';

interface ProfileImageBoxProps {
  size: number;
  profile: Profile;
}

/**
 * - 우선순위에 따라 다음과 같이 이미지를 표시
 * 1. 커스텀 이미지가 있으면 해당 이미지 표시
 * 2. 캐릭터가 선택되어 있으면 캐릭터 아이콘 표시
 * 3. 둘 다 없으면 기본 물음표 아이콘 표시
 */
function ProfileImageBox({ size, profile }: ProfileImageBoxProps) {
  const characterIndex =
    profile.image === '' ? CHARACTER_ICONS_FLAT.findIndex((icon) => icon.name === profile.character) : -1;

  return (
    <View
      style={[
        styles.profileImageBox,
        {
          backgroundColor: profile.background ?? COLORS.GRAYSCALE.WHITE_GRAY,
          width: size,
          borderRadius: size / 2,
        },
      ]}
    >
      {profile.image !== '' ? (
        <FastImage
          source={{ uri: profile.image }}
          style={styles.profileImage}
          contentFit="cover"
        />
      ) : profile.character && profile.background && characterIndex !== -1 ? (
        <FastImage
          source={CHARACTER_ICONS_FLAT[characterIndex].icon}
          style={styles.profileIcon}
          contentFit="contain"
        />
      ) : (
        <VectorIcon type="AntDesign" name="question" size={40} color={COLORS.GRAYSCALE.WHITE} />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  profileImageBox: {
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 1,
    borderColor: COLORS.GRAYSCALE.WHITE_GRAY,
    aspectRatio: 1,
    overflow: 'hidden',
  },
  profileImage: {
    width: '100%',
    height: '100%',
  },
  profileIcon: {
    width: '70%',
    height: '70%',
  },
});

export default ProfileImageBox;
