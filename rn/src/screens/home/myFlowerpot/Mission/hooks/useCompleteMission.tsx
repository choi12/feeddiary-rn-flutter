import { useMutation, useQueryClient } from '@tanstack/react-query';
import React, { useCallback } from 'react';

import { APICompleteMission, APICompleteMissionParams } from '@/api/mission/APICompleteMission';
import { MODAL_CONTENT, MODAL_BUTTON, TOAST_BOTTOM_OFFSET } from '@/constants';
import useScreenNavigation from '@/hooks/core/navigation/useScreenNavigation';
import useAlertModal from '@/hooks/store/useAlertModal';
import useErrorToast from '@/hooks/ui/feedback/useErrorToast';
import { Mission, RewardItem } from '@/types/mission';
import { AlertModalContent } from '@/types/modal';
import { invalidateQueries } from '@/utils/query/invalidateQueries';

import RewardImageBox from '../components/RewardImageBox';

function useCompleteMission() {
  const navigation = useScreenNavigation();
  const queryClient = useQueryClient();

  const { openAlertModal, closeAlertModal } = useAlertModal();
  const handleErrorWithToast = useErrorToast();

  const navigateToHome = useCallback(() => {
    closeAlertModal();
    navigation.navigate('BottomTab', { screen: 'MyFlowerpot' });
  }, [closeAlertModal, navigation]);

  const openCompleteMissionSuccessModal = useCallback(
    (rewardResponse: RewardItem) => {
      const modalContent: AlertModalContent = {
        message: MODAL_CONTENT.MISSION.REWARD,
        image: <RewardImageBox reward={rewardResponse} />,
        buttons: [
          { text: MODAL_BUTTON.COMMON.CLOSE, onPress: closeAlertModal, style: 'cancel' },
          { text: MODAL_BUTTON.REWARD.USE, onPress: navigateToHome, style: 'default' },
        ],
      };
      openAlertModal(modalContent);
    },
    [openAlertModal, closeAlertModal, navigateToHome],
  );

  const { mutateAsync: completeMissionMutation, isPending } = useMutation({
    mutationFn: async ({ missionIdx, type }: APICompleteMissionParams) => {
      const data: APICompleteMissionParams = { missionIdx, type };
      return APICompleteMission(data);
    },
    onSuccess: () => invalidateQueries.completeMission(queryClient),
  });

  const handleCompleteMission = useCallback(
    async (missionIdx: number, type: Mission) => {
      try {
        const response = await completeMissionMutation({ missionIdx, type });
        openCompleteMissionSuccessModal(response.reward);
      } catch (error) {
        handleErrorWithToast(error, TOAST_BOTTOM_OFFSET.INNER_SCREEN);
      }
    },
    [completeMissionMutation, openCompleteMissionSuccessModal, handleErrorWithToast],
  );

  return { handleCompleteMission, isPending };
}

export default useCompleteMission;
