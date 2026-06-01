import { COLORS } from '@/constants';

export const VISIBILITY_PRESET = {
  true: {
    icon: 'eye',
    text: '공개 중',
    color: COLORS.CORE.MAIN,
  },
  false: {
    icon: 'eye-off',
    text: '비공개',
    color: COLORS.GRAYSCALE.GRAY,
  },
} as const;
