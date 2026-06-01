import { createNavigationContainerRef } from '@react-navigation/native';

import { StackParamList } from '@/navigation/MainNavigation/types';

// https://reactnavigation.org/docs/navigating-without-navigation-prop/

export const navigationRef = createNavigationContainerRef<StackParamList>();
