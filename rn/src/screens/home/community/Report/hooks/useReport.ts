import { useFocusEffect } from '@react-navigation/native';
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { useCallback, useRef, useState } from 'react';
import { TextInput } from 'react-native';

import { APIReportDiary, APIReportDiaryParams } from '@/api/community/APIReportDiary';
import { MODAL_CONTENT, MODAL_BUTTON, TOAST_BOTTOM_OFFSET } from '@/constants';
import useScreenNavigation from '@/hooks/core/navigation/useScreenNavigation';
import useAlertModal from '@/hooks/store/useAlertModal';
import useUserInfo from '@/hooks/store/useUserInfo';
import useErrorToast from '@/hooks/ui/feedback/useErrorToast';
import { AlertModalContent } from '@/types/modal';
import { invalidateQueries } from '@/utils/query/invalidateQueries';

function useReport() {
  const navigation = useScreenNavigation();
  const queryClient = useQueryClient();

  const userIdx = useUserInfo('idx');

  const { openAlertModal, closeAlertModal } = useAlertModal();
  const handleErrorWithToast = useErrorToast();

  const [text, setText] = useState('');
  const inputRef = useRef<TextInput>(null);

  const navigateToCommunity = useCallback(() => {
    closeAlertModal();
    navigation.navigate('BottomTab', { screen: 'Community' });
  }, [navigation, closeAlertModal]);

  const openSuccessModal = useCallback(() => {
    const modalContent: AlertModalContent = {
      message: MODAL_CONTENT.DIARY.REPORT_COMPLETE,
      buttons: [{ text: MODAL_BUTTON.UPDATE.CONFIRM, onPress: navigateToCommunity, style: 'default' }],
      onPressBackground: navigateToCommunity,
    };
    openAlertModal(modalContent);
  }, [openAlertModal, navigateToCommunity]);

  const { mutateAsync: reportMutation, isPending } = useMutation({
    mutationFn: async (diaryIdx: number) => {
      const data: APIReportDiaryParams = {
        diaryIdx,
        text: text.trim(),
        blockIdx: userIdx as number,
      };
      await APIReportDiary(data);
    },
    onSuccess: () => invalidateQueries.reportDiary(queryClient),
  });

  const handleReport = useCallback(
    async (diaryIdx: number) => {
      try {
        await reportMutation(diaryIdx);
        openSuccessModal();
      } catch (error) {
        handleErrorWithToast(error, TOAST_BOTTOM_OFFSET.INNER_SCREEN);
      }
    },
    [reportMutation, openSuccessModal, handleErrorWithToast],
  );

  useFocusEffect(
    useCallback(() => {
      // 100ms의 지연을 주는 이유: 화면 전환 애니메이션이 끝나기 전에 포커스를 주면 버벅일 수 있기 때문
      const timer = setTimeout(() => {
        inputRef.current?.focus();
      }, 100);

      return () => clearTimeout(timer);
    }, []),
  );

  return {
    text,
    inputRef,
    setText,
    handleReport,
    isPending,
  };
}

export default useReport;
