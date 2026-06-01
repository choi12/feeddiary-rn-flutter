// calculateVerticalCenter 유틸 테스트
import { LAYOUT } from '@/constants';
import { calculateVerticalCenter } from '@/utils/common/calculateVerticalCenter';

describe('calculateVerticalCenter', () => {
  it('computes the center from height minus insets and status bar', () => {
    const height = 800;
    const bottomInset = 34;

    const adjustedHeight = height - bottomInset - LAYOUT.STATUS_BAR_HEIGHT;
    const expected = (adjustedHeight / LAYOUT.VERTICAL_POSITION_RATIO) * LAYOUT.VERTICAL_OFFSET_MULTIPLIER;

    expect(calculateVerticalCenter(height, bottomInset)).toBe(expected);
  });

  it('subtracts a larger bottom inset accordingly', () => {
    expect(calculateVerticalCenter(800, 0)).toBeGreaterThan(calculateVerticalCenter(800, 50));
  });
});
