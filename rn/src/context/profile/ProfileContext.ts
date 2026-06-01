import useTypedContext from '@/hooks/core/context/useTypedContext';
import { NicknameValidationStatus, SelectedImage } from '@/types/profile';
import { createNamedContext } from '@/utils/context/createNamedContext';

export type ProfileContext = {
  nickname: string;
  onSetNickname: (nickname: string) => void;
  notiType: NicknameValidationStatus;

  background?: string;
  onSetBackground: (background?: string) => void;
  character?: string;
  onSetCharacter: (character?: string) => void;

  selectedProfileImage: SelectedImage | undefined;
  onOpenImagePicker: () => void;
  onClearProfileImage: () => void;
};

export const ProfileContext = createNamedContext<ProfileContext | undefined>('ProfileContext', undefined);
export const useProfileContext = () => useTypedContext(ProfileContext);
