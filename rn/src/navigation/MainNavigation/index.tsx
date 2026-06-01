import { createNativeStackNavigator } from '@react-navigation/native-stack';
import React from 'react';

import {
  AppVersion,
  Comments,
  CreateDiary,
  DiaryDetails,
  License,
  LockdownSettings,
  LockScreen,
  Mission,
  Report,
  CreateLetter,
  SettingLockPassword,
  UpdateProfile,
} from '@/screens/home';
import { CreateProfile, SignIn, Update } from '@/screens/start';

import BottomTabNavigation from '../BottomTabNavigation';

import { defaultScreenOptions, lockScreenOptions } from './config';

const Stack = createNativeStackNavigator();

function MainNavigation() {
  return (
    <Stack.Navigator initialRouteName="Update" screenOptions={defaultScreenOptions}>
      {/* 앱 업데이트 체크 스크린 - 최초 진입점 */}
      <Stack.Screen name="Update" component={Update} />

      {/* 인증 관련 스크린 */}
      <Stack.Screen name="SignIn" component={SignIn} />
      <Stack.Screen name="CreateProfile" component={CreateProfile} />

      {/* 잠금 스크린 - 보안 설정이 활성화된 경우에만 표시 */}
      <Stack.Screen name="LockScreen" component={LockScreen} options={lockScreenOptions} />

      {/* 메인 탭 내비게이션 */}
      <Stack.Screen name="BottomTab" component={BottomTabNavigation} />

      {/* MyFlowerpot 관련 스크린 */}
      <Stack.Screen name="Mission" component={Mission} />

      {/* MyDiary 관련 스크린 */}
      <Stack.Screen name="CreateDiary" component={CreateDiary} />
      <Stack.Screen name="DiaryDetails" component={DiaryDetails} />

      {/* Community 관련 스크린 */}
      <Stack.Screen name="Comments" component={Comments} />
      <Stack.Screen name="Report" component={Report} />

      {/* Letter 관련 스크린 */}
      <Stack.Screen name="CreateLetter" component={CreateLetter} />

      {/* Setting 관련 스크린 */}
      <Stack.Screen name="UpdateProfile" component={UpdateProfile} />
      <Stack.Screen name="LockdownSettings" component={LockdownSettings} />
      <Stack.Screen name="SettingLockPassword" component={SettingLockPassword} />
      <Stack.Screen name="License" component={License} />
      <Stack.Screen name="AppVersion" component={AppVersion} />
    </Stack.Navigator>
  );
}

export default MainNavigation;
