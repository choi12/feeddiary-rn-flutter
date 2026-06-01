import { useCallback, useEffect } from 'react';
import { runOnJS, useSharedValue, withTiming } from 'react-native-reanimated';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import useToast from '@/hooks/store/useToast';
import { useStore } from '@/store';
import { delay } from '@/utils/common/delay';

const TOAST_CONSTANTS = {
  DISPLAY_DURATION: 2000,
  ANIMATION_DURATION: 500,
  HIDDEN_POSITION: -100,
} as const;

function useToastBox() {
  const { bottom: safeAreaBottomInset } = useSafeAreaInsets();

  const { isVisible, bottomOffset, message } = useStore((state) => state.toast);
  const { hideToast } = useToast();

  const toastPosition = useSharedValue(0);

  const hideAnimation = () => {
    return new Promise<void>((resolve) => {
      toastPosition.value = withTiming(
        TOAST_CONSTANTS.HIDDEN_POSITION,
        { duration: TOAST_CONSTANTS.ANIMATION_DURATION },

        (finished) => {
          if (finished) {
            runOnJS(resolve)();
          }
        },
      );
    });
  };

  const showToast = useCallback(async () => {
    toastPosition.value = withTiming(bottomOffset + safeAreaBottomInset);

    await delay(TOAST_CONSTANTS.DISPLAY_DURATION);
    await hideAnimation();
    hideToast();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [bottomOffset, hideToast, safeAreaBottomInset]);

  useEffect(() => {
    if (isVisible) {
      showToast();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isVisible]);

  return {
    isVisible,
    toastPosition,
    message,
  };
}

export default useToastBox;
