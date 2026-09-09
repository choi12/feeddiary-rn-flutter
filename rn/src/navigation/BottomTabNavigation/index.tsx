// 메인 하단 탭 네비게이터 — 탭 화면 등록 + 잠금 가드·푸시 컨트롤러 래핑, 플랫폼별 탭바 높이 계산
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import React, { useMemo } from 'react';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import AndroidBackgroundPushMessageController from '@/components/controller/AndroidBackgroundPushMessageController';
import ForegroundPushMessageController from '@/components/controller/ForegroundPushMessageController';
import LockScreenGuard from '@/components/guard/LockScreenGuard';
import { isiOS, LAYOUT } from '@/constants';

import BottomTabIcon from './components/BottomTabIcon';
import { tabBarOptions } from './config';
import { TAB_SCREENS } from './data';
import { TAB_BAR_LAYOUT, tabBarOptionStyle, tabBarStyle as defaultTabBarStyle } from './styles';
import { TabParamList } from './types';

const Tab = createBottomTabNavigator<TabParamList>();

const renderTabBarIcon =
  (name: keyof TabParamList) =>
  ({ focused }: { focused: boolean }) =>
    <BottomTabIcon focused={focused} name={name} />;

function BottomTabNavigation() {
  const { bottom: safeAreaBottomInset } = useSafeAreaInsets();

  const tabBarStyle = useMemo(() => {
    if (isiOS) {
      return [
        defaultTabBarStyle,
        {
          height: LAYOUT.BOTTOM_TAB_HEIGHT + (safeAreaBottomInset > 0 ? TAB_BAR_LAYOUT.SAFE_AREA_PADDING : 0),
          paddingBottom:
            safeAreaBottomInset > 0
              ? safeAreaBottomInset - TAB_BAR_LAYOUT.SAFE_AREA_BOTTOM_ADJUSTMENT
              : TAB_BAR_LAYOUT.BOTTOM_PADDING,
        },
      ];
    }

    // Android 15+ 는 Edge-to-Edge 가 강제라 시스템이 오프셋을 넣지 않는다. 실측 inset 을 쓰고(3버튼 내비는 제스처보다 크다),
    // inset 을 못 읽는 경우에만 상수로 폴백한다.
    const androidBottomInset = safeAreaBottomInset > 0 ? safeAreaBottomInset : LAYOUT.BOTTOM_INSET_ANDROID;

    return [
      defaultTabBarStyle,
      {
        height: LAYOUT.BOTTOM_TAB_HEIGHT + androidBottomInset,
        paddingBottom: TAB_BAR_LAYOUT.BOTTOM_PADDING + androidBottomInset,
      },
    ];
  }, [safeAreaBottomInset]);

  return (
    <LockScreenGuard>
      <AndroidBackgroundPushMessageController>
        <ForegroundPushMessageController>
          <Tab.Navigator
            initialRouteName="MyFlowerpot"
            screenOptions={{ ...tabBarOptions, ...tabBarOptionStyle, tabBarStyle }}
          >
            {TAB_SCREENS.map(({ name, component, label }) => (
              <Tab.Screen
                key={name}
                name={name}
                component={component}
                options={{
                  tabBarIcon: renderTabBarIcon(name),
                  tabBarLabel: label,
                }}
              />
            ))}
          </Tab.Navigator>
        </ForegroundPushMessageController>
      </AndroidBackgroundPushMessageController>
    </LockScreenGuard>
  );
}

export default BottomTabNavigation;
