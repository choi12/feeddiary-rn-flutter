// 앱 시작 시 초기 설정 — 토큰 로드·스플래시 숨김·상태바·알림 권한 요청
import { StatusBar } from 'react-native';
import BootSplash from 'react-native-bootsplash';
import { requestNotifications } from 'react-native-permissions';

import { COLORS, isAndroid } from '@/constants';

import { delay } from '../common/delay';
import { loadAccessToken } from '../storage/auth';

const hideSplash = async () => {
  await delay(1500);
  try {
    await BootSplash.hide({ fade: true });
  } catch {
    // 네이티브 스플래시 숨김 실패는 무시(핫리로드·테스트 등). 네이티브 와이어업 완료(AppDelegate/MainActivity).
  }
};

const setStatusBar = () => {
  StatusBar.setBarStyle('dark-content');
  // iOS는 기본적으로 투명한 상태바를 사용
  if (isAndroid) {
    StatusBar.setBackgroundColor(COLORS.GRAYSCALE.WHITE);
  }
};

export const setupInitialAppConfig = async () => {
  await loadAccessToken();
  await hideSplash();
  setStatusBar();
  await requestNotifications(['alert', 'badge', 'sound']);
};
