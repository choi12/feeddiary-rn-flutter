import React, { PropsWithChildren } from 'react';
import Animated, { useAnimatedStyle, withTiming } from 'react-native-reanimated';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import { isAndroid } from '@/constants';
import useKeyboardState from '@/hooks/ui/interaction/useKeyboardState';

/**
 * 키보드가 열릴 때 내부 컨텐츠를 자동으로 조정하는 컨테이너
 * - iOS: 키보드 높이만큼 컨텐츠를 위로 이동 (safe area 제외)
 * - Android: windowSoftInputMode="adjustResize" 설정 사용
 */
function KeyboardAwareBox({ children }: PropsWithChildren) {
  const { bottom } = useSafeAreaInsets();
  const { isKeyboardVisible, keyboardHeight } = useKeyboardState();

  const getKeyboardSpacing = () => {
    'worklet';
    if (!isKeyboardVisible) return 0;

    return isAndroid ? 0 : keyboardHeight - bottom;
  };

  const animatedBoxStyle = useAnimatedStyle(
    () => ({
      paddingBottom: withTiming(getKeyboardSpacing()),
    }),
    [isKeyboardVisible, isAndroid, keyboardHeight, bottom],
  );

  return <Animated.View style={animatedBoxStyle}>{children}</Animated.View>;
}

export default KeyboardAwareBox;
