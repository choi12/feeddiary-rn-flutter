// 회원가입 오케스트레이션 훅 — 프로필 폼을 FormData로 전송·가입 후 토큰 저장 및 메인 진입
import { useMutation } from '@tanstack/react-query';
import { useCallback } from 'react';

import { APISignUp, APISignUpParams } from '@/api/auth/APISignUp';
import { UserDTO } from '@/api/auth/types';
import { MESSAGE, TOAST_BOTTOM_OFFSET } from '@/constants';
import { useProfileContext } from '@/context/profile/ProfileContext';
import useScreenNavigation from '@/hooks/core/navigation/useScreenNavigation';
import useLoading from '@/hooks/store/useLoading';
import useToast from '@/hooks/store/useToast';
import useErrorToast from '@/hooks/ui/feedback/useErrorToast';
import { useStore } from '@/store';
import { SignInType } from '@/types/auth';
import { delay } from '@/utils/common/delay';
import { getFCMToken } from '@/utils/notifications/messagingToken';
import { setAccessToken } from '@/utils/storage/auth';

interface UseSignUpProps {
  type: SignInType;
  email: string;
  uid: string;
}

function useSignUp({ type, email, uid }: UseSignUpProps) {
  const navigation = useScreenNavigation();

  const saveUser = useStore((state) => state.saveUser);
  const { notiType, nickname, selectedProfileImage, background, character } = useProfileContext();

  const { showLoading, hideLoading } = useLoading();
  const { showToast } = useToast();
  const handleErrorWithToast = useErrorToast();

  const isSignUpDisabled = notiType !== 'success' || (!selectedProfileImage && !(!!background && !!character));

  const prepareFormData = async (): Promise<FormData> => {
    const fcmToken = await getFCMToken();
    const data = new FormData();
    data.append('type', type);
    data.append('account', email);
    data.append('user_id', uid);
    data.append('nickname', nickname.trim());
    data.append('image', selectedProfileImage ?? '');
    data.append('background', background ?? '');
    data.append('character', character ?? '');
    data.append('fcm_token', fcmToken);

    return data;
  };

  const showWelcomeToast = useCallback(async () => {
    await delay(500);
    showToast(MESSAGE.SYSTEM.WELCOME, TOAST_BOTTOM_OFFSET.HOME_SCREEN);
  }, [showToast]);

  const { mutateAsync: signUpMutation, isPending } = useMutation({
    mutationFn: async () => {
      const formData = await prepareFormData();
      const data: APISignUpParams = {
        signUpFormData: formData,
      };
      return APISignUp(data);
    },
  });

  const handleSignUp = useCallback(async () => {
    try {
      showLoading();

      const response = await signUpMutation();
      const userInfo: UserDTO = {
        ...response,
        image: response.image ?? '',
        background: response.background ?? '',
        character: response.character ?? '',
      };
      saveUser(userInfo);
      await setAccessToken(userInfo.token);

      hideLoading();
      navigation.reset({ routes: [{ name: 'BottomTab' }] });
      showWelcomeToast();
    } catch (error) {
      hideLoading();
      handleErrorWithToast(error, TOAST_BOTTOM_OFFSET.BUTTON_SCREEN);
    }
  }, [signUpMutation, handleErrorWithToast, hideLoading, navigation, saveUser, showLoading, showWelcomeToast]);

  return { handleSignUp, isPending, isSignUpDisabled };
}

export default useSignUp;
