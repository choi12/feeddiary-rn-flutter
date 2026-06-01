import { useMutation } from '@tanstack/react-query';
import { useCallback, useMemo } from 'react';

import { APIUpdateProfile, APIUpdateProfileParams } from '@/api/user/APIUpdateProfile';
import { MESSAGE, TOAST_BOTTOM_OFFSET } from '@/constants';
import { useProfileContext } from '@/context/profile/ProfileContext';
import useScreenNavigation from '@/hooks/core/navigation/useScreenNavigation';
import useLoading from '@/hooks/store/useLoading';
import useToast from '@/hooks/store/useToast';
import useUserInfo from '@/hooks/store/useUserInfo';
import useErrorToast from '@/hooks/ui/feedback/useErrorToast';
import { useStore } from '@/store';

function useUpdateProfile() {
  const navigation = useScreenNavigation();

  const saveUser = useStore((state) => state.saveUser);
  const { nickname, selectedProfileImage, background, character, notiType } = useProfileContext();
  const userNickname = useUserInfo('nickname');

  const { showLoading, hideLoading } = useLoading();
  const { showToast } = useToast();
  const handleErrorWithToast = useErrorToast();

  const isUpdateProfileDisabled = useMemo(() => {
    const hasInvalidNotification = notiType === 'duplicate' || notiType === 'regex';
    const hasNoChanges = userNickname === nickname && !selectedProfileImage && !(background && character);
    const hasNoNickname = !nickname;

    return hasInvalidNotification || hasNoChanges || hasNoNickname;
  }, [notiType, userNickname, nickname, selectedProfileImage, background, character]);

  const prepareFormData = (): FormData => {
    const data = new FormData();
    data.append('nickname', nickname.trim());
    data.append('image', selectedProfileImage ?? null);
    data.append('background', background ?? '');
    data.append('character', character ?? '');

    return data;
  };

  const { mutateAsync: updateProfileMutation, isPending } = useMutation({
    mutationFn: async () => {
      const formData = prepareFormData();
      const data: APIUpdateProfileParams = {
        updateProfileFormData: formData,
      };
      return APIUpdateProfile(data);
    },
  });

  const handleSubmitProfile = useCallback(async () => {
    try {
      showLoading();

      const response = await updateProfileMutation();
      saveUser({ ...response, image: response.image ?? '' });

      hideLoading();
      navigation.goBack();
      showToast(MESSAGE.ACCOUNT.PROFILE_UPDATED, TOAST_BOTTOM_OFFSET.HOME_SCREEN);
    } catch (error) {
      hideLoading();
      handleErrorWithToast(error, TOAST_BOTTOM_OFFSET.BUTTON_SCREEN);
    }
  }, [handleErrorWithToast, hideLoading, navigation, saveUser, showLoading, showToast, updateProfileMutation]);

  return { handleSubmitProfile, isPending, isUpdateProfileDisabled };
}

export default useUpdateProfile;
