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
    // native init 미와이어 시 silent — generate-bootsplash + AppDelegate/MainActivity wire-up 후 제거
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
