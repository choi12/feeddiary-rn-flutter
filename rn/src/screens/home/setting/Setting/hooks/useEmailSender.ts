import { useState } from 'react';

import { TOAST_BOTTOM_OFFSET } from '@/constants';
import useUserInfo from '@/hooks/store/useUserInfo';
import useErrorToast from '@/hooks/ui/feedback/useErrorToast';

import { EmailSender } from '../types';
import { sendSupportEmail } from '../utils/sendEmail';

function useEmailSender() {
  const [isPending, setIsPending] = useState(false);
  const { nickname, account } = useUserInfo(['nickname', 'account']) ?? {};
  const handleErrorWithToast = useErrorToast();

  const sendEmail = async () => {
    if (isPending) return;

    const senderInfo: EmailSender = { nickname: nickname ?? '닉네임 없음', account: account ?? '계정 없음' };
    setIsPending(true);
    try {
      await sendSupportEmail(senderInfo);
    } catch (error) {
      handleErrorWithToast(error, TOAST_BOTTOM_OFFSET.HOME_SCREEN);
    } finally {
      setIsPending(false);
    }
  };

  return { sendEmail };
}

export default useEmailSender;
