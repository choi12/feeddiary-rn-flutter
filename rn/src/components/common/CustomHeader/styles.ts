import { TextStyle } from 'react-native';

import { COLORS, FONTS } from '@/constants';

export type FontType = 'DOVEMAYO' | 'ONGLE';

export const FONT_STYLES: Record<FontType, TextStyle> = {
  DOVEMAYO: {
    fontFamily: FONTS.DOVEMAYO,
    fontSize: 17,
    color: COLORS.GRAYSCALE.BLACK,
  },
  ONGLE: {
    fontFamily: FONTS.ONGLE,
    fontSize: 24,
    color: COLORS.GRAYSCALE.LIGHT_BLACK,
    letterSpacing: -0.5,
  },
};
