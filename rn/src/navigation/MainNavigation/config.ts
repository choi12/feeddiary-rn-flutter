import { NativeStackNavigationOptions } from '@react-navigation/native-stack';

export const defaultScreenOptions: NativeStackNavigationOptions = {
  presentation: 'card',
  animation: 'slide_from_right',
  headerShown: false,
};

export const lockScreenOptions: NativeStackNavigationOptions = { animation: 'fade', gestureEnabled: false };
