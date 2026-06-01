import { LAYOUT } from '@/constants';

// 화면 중앙 기준 수직 위치 계산
export const calculateVerticalCenter = (height: number, bottomInset: number) => {
  const adjustedHeight = height - bottomInset - LAYOUT.STATUS_BAR_HEIGHT;

  return (adjustedHeight / LAYOUT.VERTICAL_POSITION_RATIO) * LAYOUT.VERTICAL_OFFSET_MULTIPLIER;
};
