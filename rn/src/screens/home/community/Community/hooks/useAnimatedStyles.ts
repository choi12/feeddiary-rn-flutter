import { useWindowDimensions } from 'react-native';
import { useAnimatedStyle, withTiming } from 'react-native-reanimated';

import { COLORS } from '@/constants';

import { useCommunityHeaderContext } from '../context/CommunityHeaderContext';

const ANIMATED_BUTTON_CONSTANTS = {
  DEFAULT_WIDTH: 82,
  PADDING_RIGHT: 12,
  BORDER_RADIUS: 12,
} as const;

/**
 * 스크롤 상태에 따라 헤더 스타일 변경
 * - 스크롤 되지 않은 상태: 오른쪽에 작은 정렬 버튼이 존재하는 BACKGROUND 헤더
 * - 스크롤 시: 정렬 버튼이 전체 너비로 확장된 WHITE 헤더
 */
function useAnimatedStyles() {
  const { width } = useWindowDimensions();
  const { isScrolled } = useCommunityHeaderContext();

  const animatedStatusBoxStyle = useAnimatedStyle(
    () => ({
      backgroundColor: withTiming(isScrolled ? COLORS.GRAYSCALE.WHITE : COLORS.CORE.BACKGROUND),
    }),
    [isScrolled],
  );

  const animatedButtonBoxStyle = useAnimatedStyle(
    () => ({
      paddingRight: withTiming(isScrolled ? 0 : ANIMATED_BUTTON_CONSTANTS.PADDING_RIGHT),
      backgroundColor: withTiming(isScrolled ? COLORS.GRAYSCALE.WHITE : COLORS.CORE.BACKGROUND),
    }),
    [isScrolled],
  );

  const animatedButtonStyle = useAnimatedStyle(
    () => ({
      width: withTiming(isScrolled ? width : ANIMATED_BUTTON_CONSTANTS.DEFAULT_WIDTH),
      borderRadius: withTiming(isScrolled ? 0 : ANIMATED_BUTTON_CONSTANTS.BORDER_RADIUS),
    }),
    [isScrolled, width],
  );

  return {
    animatedStatusBoxStyle,
    animatedButtonBoxStyle,
    animatedButtonStyle,
  };
}

export default useAnimatedStyles;
