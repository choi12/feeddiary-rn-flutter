import { isAndroid } from '../environment/platform';

import { LAYOUT } from './layout';

export const TOAST_BOTTOM_OFFSET = {
  HOME_SCREEN: LAYOUT.BOTTOM_TAB_HEIGHT + (isAndroid ? LAYOUT.BOTTOM_INSET_ANDROID : 0),
  BUTTON_SCREEN: LAYOUT.BUTTON_HEIGHT + LAYOUT.PADDING + 20,
  INNER_SCREEN: 20,

  DIARY_DETAILS: 65,
  COMMENT: 80,
} as const;
