import { useMutation } from '@tanstack/react-query';
import { useCallback, useEffect, useState } from 'react';

import { APICheckNickname, APICheckNicknameParams } from '@/api/auth/APICheckNickname';
import { NICKNAME_REGEX, TOAST_BOTTOM_OFFSET } from '@/constants';
import useDebounce from '@/hooks/core/useDebounce';
import useUserInfo from '@/hooks/store/useUserInfo';
import { ConflictError } from '@/types/errors';
import { NicknameValidationStatus } from '@/types/profile';
import { convertToLowercase } from '@/utils/common/convertCase';

import useErrorToast from '../../ui/feedback/useErrorToast';

function useCheckNickname() {
  const userNickname = useUserInfo('nickname');

  const [notiType, setNotiType] = useState<NicknameValidationStatus>();
  const [nickname, setNickname] = useState(userNickname ?? '');

  const debouncedNickname = useDebounce({ value: nickname });
  const handleErrorWithToast = useErrorToast();

  const { mutateAsync: checkDuplicationMutation } = useMutation({
    mutationFn: async (nicknameToCheck: string) => {
      const data: APICheckNicknameParams = {
        nickname: nicknameToCheck.trim(),
      };
      return APICheckNickname(data);
    },
  });

  const checkDuplication = useCallback(
    async (nicknameToCheck: string) => {
      try {
        const response = await checkDuplicationMutation(nicknameToCheck);
        if (response === 'success') {
          setNotiType('success');
        }
      } catch (error) {
        if (error instanceof ConflictError) {
          setNotiType('duplicate');
          return;
        }
        handleErrorWithToast(error, TOAST_BOTTOM_OFFSET.BUTTON_SCREEN);
        setNotiType(undefined);
      }
    },
    [checkDuplicationMutation, handleErrorWithToast],
  );

  const checkNicknameValidity = useCallback(async () => {
    if (!debouncedNickname) {
      setNotiType(undefined);
      return;
    }

    const isSameAsCurrentNickname =
      userNickname && convertToLowercase(debouncedNickname) === convertToLowercase(userNickname);
    if (isSameAsCurrentNickname) {
      setNotiType(undefined);
      return;
    }

    if (!NICKNAME_REGEX.test(debouncedNickname)) {
      setNotiType('regex');
      return;
    }

    await checkDuplication(debouncedNickname);
  }, [debouncedNickname, checkDuplication, userNickname]);

  useEffect(() => {
    checkNicknameValidity();
  }, [debouncedNickname, checkNicknameValidity]);

  return { notiType, nickname, setNickname };
}

export default useCheckNickname;
