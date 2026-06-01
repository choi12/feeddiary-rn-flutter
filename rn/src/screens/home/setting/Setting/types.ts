import { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { ReactNode } from 'react';

import { StackParamList } from '@/navigation/MainNavigation/types';

type MenuItemTitle = '잠금 설정' | '문의하기' | '오픈소스 라이선스' | '앱 버전 정보';

export type EmailSender = { nickname: string; account: string };

export type SettingMenuConfig = {
  title: MenuItemTitle;
  icon?: ReactNode;
  onPress: (_: NativeStackNavigationProp<StackParamList>, senderInfo?: EmailSender) => void | Promise<void>;
};
