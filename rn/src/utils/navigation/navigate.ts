import { CommonActions } from '@react-navigation/native';

import { StackParamList } from '@/navigation/MainNavigation/types';

import { navigationRef } from './navigationRef';

export function navigate<T extends keyof StackParamList>(name: T, params?: StackParamList[T]) {
  if (navigationRef.isReady()) {
    navigationRef.dispatch(CommonActions.navigate(name, params));
  }
}
