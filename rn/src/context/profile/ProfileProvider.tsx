import React, { PropsWithChildren, useMemo, useState } from 'react';

import useCheckNickname from '@/hooks/features/profile/useCheckNickname';
import useUserInfo from '@/hooks/store/useUserInfo';
import useImagePicker from '@/hooks/ui/interaction/useImagePicker';

import { ProfileContext } from './ProfileContext';

function ProfileProvider({ children }: PropsWithChildren) {
  const { background: userBackground, character: userCharacter } = useUserInfo(['background', 'character']) ?? {};

  const [background, setBackground] = useState<string | undefined>(userBackground);
  const [character, setCharacter] = useState<string | undefined>(userCharacter);

  const { notiType, nickname, setNickname } = useCheckNickname();
  const { handleOpenImagePicker, selectedImage, handleClearImage } = useImagePicker();

  const contextValue: ProfileContext = useMemo(
    () => ({
      nickname,
      onSetNickname: setNickname,
      notiType,
      background,
      onSetBackground: setBackground,
      character,
      onSetCharacter: setCharacter,
      selectedProfileImage: selectedImage,
      onOpenImagePicker: handleOpenImagePicker,
      onClearProfileImage: handleClearImage,
    }),
    [nickname, setNickname, notiType, background, character, selectedImage, handleOpenImagePicker, handleClearImage],
  );

  return <ProfileContext.Provider value={contextValue}>{children}</ProfileContext.Provider>;
}
export default ProfileProvider;
