import { useCallback, useState } from 'react';
import { GestureResponderEvent, useWindowDimensions } from 'react-native';
import {
  runOnJS,
  useAnimatedStyle,
  useSharedValue,
  withSpring,
  withTiming,
  Easing,
  WithSpringConfig,
  WithTimingConfig,
} from 'react-native-reanimated';

import { LetterDTO } from '@/api/letter/types';
import useVisibility from '@/hooks/ui/animation/useVisibility';

type Position = {
  x: number;
  y: number;
};

const SPRING_ANIMATION_CONFIG: WithSpringConfig = {
  damping: 100,
  stiffness: 300,
};
const TIMING_ANIMATION_CONFIG: WithTimingConfig = {
  duration: 300,
  easing: Easing.ease,
};

const INITIAL_SCALE = 0.5;

function useAnimatedLetterModal() {
  const { width, height } = useWindowDimensions();

  const [selectedLetter, setSelectedLetter] = useState<LetterDTO>();
  const [originPosition, setOriginPosition] = useState<Position>({ x: 0, y: 0 });
  const { isVisible: letterModalVisible, show: openLetterModal, hide: closeLetterModal } = useVisibility();

  const scale = useSharedValue(INITIAL_SCALE);
  const opacity = useSharedValue(0);
  const translateX = useSharedValue(0);
  const translateY = useSharedValue(0);

  const showModalAnimation = useCallback(() => {
    translateX.value = withSpring(0, SPRING_ANIMATION_CONFIG);
    translateY.value = withSpring(0, SPRING_ANIMATION_CONFIG);
    scale.value = withSpring(1, SPRING_ANIMATION_CONFIG);
    opacity.value = withTiming(1, TIMING_ANIMATION_CONFIG);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const hideModalAnimation = useCallback(
    (returnDistanceX: number, returnDistanceY: number) => {
      translateX.value = withSpring(returnDistanceX, SPRING_ANIMATION_CONFIG);
      translateY.value = withSpring(returnDistanceY, SPRING_ANIMATION_CONFIG);
      scale.value = withSpring(INITIAL_SCALE, SPRING_ANIMATION_CONFIG);

      return new Promise<void>((resolve) => {
        opacity.value = withTiming(0, TIMING_ANIMATION_CONFIG, (finished) => {
          if (finished) {
            runOnJS(resolve)();
          }
        });
      });
    },
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [closeLetterModal],
  );

  const getModalOffset = useCallback(
    (touchX: number, touchY: number) => {
      const screenCenterX = width / 2;
      const screenCenterY = height / 2;

      return {
        offsetFromCenter: touchX - screenCenterX,
        offsetFromCenterY: touchY - screenCenterY,
      };
    },
    [width, height],
  );

  const handleOpenLetterModal = useCallback(
    (event: GestureResponderEvent, letter: LetterDTO) => {
      const { pageX: touchStartX, pageY: touchStartY } = event.nativeEvent;
      const { offsetFromCenter, offsetFromCenterY } = getModalOffset(touchStartX, touchStartY);

      setOriginPosition({ x: touchStartX, y: touchStartY });

      // 1. 초기 위치 설정: 원래 모달의 위치는 중앙인데, 누른 위치에서 등장하도록 offsetFromCenter 만큼 미리 이동시켜 놓음
      translateX.value = offsetFromCenter;
      translateY.value = offsetFromCenterY;

      setSelectedLetter(letter);
      openLetterModal();
      showModalAnimation(); // 2. 여기서 다시 편지 모달을 중앙(0)으로 이동시킴
    },
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [getModalOffset, openLetterModal, showModalAnimation],
  );

  const handleCloseLetterModal = useCallback(async () => {
    const { offsetFromCenter: returnDistanceX, offsetFromCenterY: returnDistanceY } = getModalOffset(
      originPosition.x,
      originPosition.y,
    );

    await hideModalAnimation(returnDistanceX, returnDistanceY);
    closeLetterModal();
    setSelectedLetter(undefined);
  }, [originPosition, getModalOffset, hideModalAnimation, closeLetterModal]);

  const animatedStyle = useAnimatedStyle(() => ({
    transform: [{ translateX: translateX.value }, { translateY: translateY.value }, { scale: scale.value }],
    opacity: opacity.value,
  }));

  return {
    selectedLetter,
    letterModalVisible,
    handleOpenLetterModal,
    handleCloseLetterModal,
    animatedStyle,
  };
}

export default useAnimatedLetterModal;
