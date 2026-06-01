import React, { useState } from 'react';
import { Pressable, StyleSheet, View } from 'react-native';

import Text from '@/components/common/Text';
import { COLORS } from '@/constants';
import { useProfileContext } from '@/context/profile/ProfileContext';
import useUserInfo from '@/hooks/store/useUserInfo';
import useVisibility from '@/hooks/ui/animation/useVisibility';
import { Profile } from '@/types/profile';
import { delay } from '@/utils/common/delay';

import ProfileAvatarEditor from './ProfileAvatarEditor';
import ProfileImageBox from './ProfileImageBox';
import ProfileImageTypeModal from './ProfileImageTypeModal';
import ProfilePhotoSelector from './ProfilePhotoSelector';

type ProfileImage = 'photo' | 'character' | undefined;

interface ProfileImageSectionProps {
  scrollToEnd: () => void;
}

function ProfileImageSection({ scrollToEnd }: ProfileImageSectionProps) {
  const { image: userImage, character: userCharacter } = useUserInfo(['image', 'character']) ?? {};
  const {
    background,
    onSetBackground,
    character,
    onSetCharacter,
    selectedProfileImage,
    onOpenImagePicker,
    onClearProfileImage,
  } = useProfileContext();

  const initialProfileImageType: ProfileImage =
    userImage || userCharacter ? (userImage ? 'photo' : 'character') : undefined;
  const [profileImageType, setProfileImageType] = useState<ProfileImage>(initialProfileImageType);

  const profile: Profile = {
    image: profileImageType === 'character' ? '' : selectedProfileImage?.uri || userImage || '',
    background: background ?? '',
    character: character ?? '',
  };

  const { isVisible: isModalVisible, show: openModal, hide: closeModal } = useVisibility();

  const handleSelectProfileType = async (type: 'photo' | 'character') => {
    setProfileImageType(type);
    closeModal();

    if (type === 'photo') {
      await delay(10);
      onOpenImagePicker();

      onSetBackground(undefined);
      onSetCharacter(undefined);
    } else {
      onClearProfileImage();
    }
  };

  return (
    <>
      <View style={styles.container}>
        <Text style={styles.sectionTitle}>프로필 이미지</Text>
        <Pressable onPress={openModal} style={styles.profileImageButton}>
          {profileImageType === 'photo' ? (
            <ProfilePhotoSelector
              selectedImage={selectedProfileImage}
              onOpenImagePicker={onOpenImagePicker}
              onClearImage={onClearProfileImage}
            />
          ) : (
            <ProfileImageBox size={160} profile={profile} />
          )}
        </Pressable>
      </View>
      {profileImageType === 'character' && (
        <ProfileAvatarEditor
          scrollToEnd={scrollToEnd}
          background={background}
          onSetBackground={onSetBackground}
          character={character}
          onSetCharacter={onSetCharacter}
        />
      )}
      <ProfileImageTypeModal
        isVisible={isModalVisible}
        onSelectPhotoType={() => handleSelectProfileType('photo')}
        onSelectCharacterType={() => handleSelectProfileType('character')}
        onCancel={closeModal}
      />
    </>
  );
}

const styles = StyleSheet.create({
  container: {
    alignItems: 'center',
    gap: 10,
    marginBottom: 25,
  },
  sectionTitle: {
    fontSize: 15,
    color: COLORS.GRAYSCALE.BLACK,
    alignSelf: 'flex-start',
  },
  profileImageButton: {
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 1,
    borderColor: COLORS.GRAYSCALE.WHITE_GRAY,
    aspectRatio: 1,
    width: 160,
    height: 160,
    backgroundColor: COLORS.GRAYSCALE.WHITE_GRAY,
    borderRadius: 80,
    overflow: 'hidden',
  },
});

export default ProfileImageSection;
