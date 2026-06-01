import { useMutation, useQueryClient } from '@tanstack/react-query';
import { useCallback } from 'react';

import { APILovePlant } from '@/api/flowerpot/APILovePlant';
import { APIWateringPlant } from '@/api/flowerpot/APIWateringPlant';
import { TOAST_BOTTOM_OFFSET } from '@/constants';
import useThrottle from '@/hooks/core/useThrottle';
import useErrorToast from '@/hooks/ui/feedback/useErrorToast';
import { invalidateQueries } from '@/utils/query/invalidateQueries';

import useLottieAnimation from './useLottieAnimation';

const ANIMATION_DURATION = 2500;

function usePlantInteraction() {
  const queryClient = useQueryClient();
  const handleErrorWithToast = useErrorToast();

  const { isAnimationVisible: isWateringAnimationVisible, showAnimation: showWateringAnimation } = useLottieAnimation({
    duration: ANIMATION_DURATION,
  });
  const { isAnimationVisible: isLoveAnimationVisible, showAnimation: showLoveAnimation } = useLottieAnimation({
    duration: ANIMATION_DURATION,
  });

  const { mutateAsync: wateringPlantMutation } = useMutation({
    mutationFn: APIWateringPlant,
    onSuccess: () => invalidateQueries.wateringPlant(queryClient),
  });

  const wateringPlant = useCallback(async () => {
    try {
      await wateringPlantMutation();
      showWateringAnimation();
    } catch (error) {
      handleErrorWithToast(error, TOAST_BOTTOM_OFFSET.HOME_SCREEN);
    }
  }, [handleErrorWithToast, showWateringAnimation, wateringPlantMutation]);

  const { mutateAsync: lovePlantMutation } = useMutation({
    mutationFn: APILovePlant,
    onSuccess: () => invalidateQueries.lovePlant(queryClient),
  });

  const lovePlant = useCallback(async () => {
    try {
      await lovePlantMutation();
      showLoveAnimation();
    } catch (error) {
      handleErrorWithToast(error, TOAST_BOTTOM_OFFSET.HOME_SCREEN);
    }
  }, [handleErrorWithToast, showLoveAnimation, lovePlantMutation]);

  const throttledWateringPlant = useThrottle({ callback: wateringPlant });
  const throttledLovePlant = useThrottle({ callback: lovePlant });

  return {
    isWateringAnimationVisible,
    isLoveAnimationVisible,
    handleWateringPlant: throttledWateringPlant,
    handleLovePlant: throttledLovePlant,
  };
}

export default usePlantInteraction;
