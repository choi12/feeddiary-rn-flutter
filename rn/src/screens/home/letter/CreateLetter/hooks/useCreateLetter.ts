import { useMutation, useQueryClient } from '@tanstack/react-query';
import { useCallback, useState } from 'react';

import { APICreateLetter, APICreateLetterParams } from '@/api/letter/APICreateLetter';
import { TOAST_BOTTOM_OFFSET } from '@/constants';
import useScreenNavigation from '@/hooks/core/navigation/useScreenNavigation';
import useToast from '@/hooks/store/useToast';
import useErrorToast from '@/hooks/ui/feedback/useErrorToast';
import { invalidateQueries } from '@/utils/query/invalidateQueries';

function useCreateLetter() {
  const queryClient = useQueryClient();
  const navigation = useScreenNavigation();

  const { showToast } = useToast();
  const handleErrorWithToast = useErrorToast();

  const [text, setText] = useState('');

  const { mutateAsync: createLetterMutation, isPending } = useMutation({
    mutationFn: async () => {
      const data: APICreateLetterParams = {
        text: text.trim(),
      };
      await APICreateLetter(data);
    },
    onSuccess: () => invalidateQueries.createLetter(queryClient),
  });

  const handleSubmitLetter = useCallback(async () => {
    try {
      await createLetterMutation();
      navigation.replace('BottomTab', { screen: 'Letters' });
      showToast('나에게 편지를 보냈어요.', TOAST_BOTTOM_OFFSET.HOME_SCREEN);
    } catch (error) {
      handleErrorWithToast(error, TOAST_BOTTOM_OFFSET.HOME_SCREEN);
    }
  }, [createLetterMutation, showToast, handleErrorWithToast, navigation]);

  return {
    text,
    setText,
    handleSubmitLetter,
    isPending,
  };
}

export default useCreateLetter;
