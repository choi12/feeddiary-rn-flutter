import { BottomTabNavigationOptions } from '@react-navigation/bottom-tabs';
import { ViewStyle } from 'react-native';

import { COLORS, FONTS, LAYOUT } from '@/constants';

export const tabBarOptionStyle: BottomTabNavigationOptions = {
  tabBarActiveTintColor: COLORS.CORE.MAIN,
  tabBarInactiveTintColor: COLORS.GRAYSCALE.LIGHT_GRAY,
  tabBarLabelStyle: {
    fontFamily: FONTS.DOVEMAYO,
    fontSize: 11,
    marginTop: 0,
    marginBottom: 5,
    letterSpacing: -0.5,
  },
};

export const tabBarStyle: ViewStyle = {
  boxShadow: '0px -2px 8px rgba(0, 0, 0, 0.08)',
  height: LAYOUT.BOTTOM_TAB_HEIGHT,
  borderTopLeftRadius: 20,
  borderTopRightRadius: 20,
  paddingBottom: 10,
  paddingHorizontal: LAYOUT.PADDING,
  position: 'absolute',
  left: 0,
  right: 0,
  bottom: 0,
  backgroundColor: COLORS.GRAYSCALE.WHITE,
};

export const TAB_BAR_LAYOUT = {
  SAFE_AREA_PADDING: 20,
  BOTTOM_PADDING: 10,
  SAFE_AREA_BOTTOM_ADJUSTMENT: 3,
} as const;
