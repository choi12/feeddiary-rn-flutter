import { Community, Letters, MyDiary, MyFlowerpot, Setting } from '@/screens/home';

import { TabScreen } from './types';

export const TAB_SCREENS: TabScreen[] = [
  { name: 'MyFlowerpot', component: MyFlowerpot, label: '나의 화분' },
  { name: 'MyDiary', component: MyDiary, label: '나의 일기' },
  { name: 'Community', component: Community, label: '공유 일기' },
  { name: 'Letters', component: Letters, label: '나의 편지' },
  { name: 'Setting', component: Setting, label: '설정' },
];
