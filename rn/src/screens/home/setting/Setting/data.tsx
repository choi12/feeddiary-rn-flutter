import React from 'react';

import VectorIcon from '@/components/common/VectorIcon';
import { COLORS } from '@/constants';

import { SettingMenuConfig } from './types';
import { sendSupportEmail } from './utils/sendEmail';

export const SETTING_MENU_ITEMS: SettingMenuConfig[] = [
  {
    title: '잠금 설정',
    icon: <VectorIcon type="AntDesign" name="lock" color={COLORS.GRAYSCALE.LIGHT_BLACK} size={19} />,
    onPress: (navigation) => navigation.navigate('LockdownSettings'),
  },
  {
    title: '문의하기',
    icon: (
      <VectorIcon type="MaterialCommunityIcons" name="email-outline" color={COLORS.GRAYSCALE.LIGHT_BLACK} size={17} />
    ),
    onPress: (_, senderInfo) => sendSupportEmail(senderInfo!),
  },
  {
    title: '오픈소스 라이선스',
    onPress: (navigation) => navigation.navigate('License'),
  },
  {
    title: '앱 버전 정보',
    onPress: (navigation) => navigation.navigate('AppVersion'),
  },
];
