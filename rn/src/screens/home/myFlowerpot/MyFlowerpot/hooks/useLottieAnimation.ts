import { useCallback, useEffect, useState } from 'react';

import { delay } from '@/utils/common/delay';

interface UseLottieAnimationProps {
  duration: number;
}
function useLottieAnimation({ duration }: UseLottieAnimationProps) {
  const [isAnimationVisible, setIsAnimationVisible] = useState(false);

  const showAnimation = useCallback(() => {
    setIsAnimationVisible(true);
  }, []);

  const hideAnimation = useCallback(async () => {
    await delay(duration);
    setIsAnimationVisible(false);
  }, [duration]);

  useEffect(() => {
    if (isAnimationVisible) {
      hideAnimation();
    }
  }, [isAnimationVisible, hideAnimation]);

  return { isAnimationVisible, showAnimation };
}

export default useLottieAnimation;
