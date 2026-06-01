import { NavigatorScreenParams } from '@react-navigation/native';

import { MyDiaryDTO } from '@/api/diary/types';
import { SignInParams } from '@/types/auth';

import { TabParamList } from '../BottomTabNavigation/types';

export type StackParamList = {
  Update: undefined;
  LockScreen: {
    isBackground?: boolean;
  };
  SignIn: undefined;
  CreateProfile: SignInParams;

  BottomTab: NavigatorScreenParams<TabParamList>;

  Mission: undefined;

  CreateDiary: {
    diary?: MyDiaryDTO;
  };
  DiaryDetails: {
    diaryIdx: number;
  };

  Comments: {
    diaryIdx: number;
    author: string;
  };
  Report: {
    diaryIdx: number;
  };

  CreateLetter: undefined;

  UpdateProfile: undefined;
  LockdownSettings: undefined;
  SettingLockPassword: undefined;
  License: undefined;
  AppVersion: undefined;
};
