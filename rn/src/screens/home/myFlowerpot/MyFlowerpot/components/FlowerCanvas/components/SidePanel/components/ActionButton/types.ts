import type { ImageProps } from 'expo-image';

export type ActionControlConfig = {
  onPress: () => void;
  disabled: boolean;
  count: number;
  style: ImageProps['style'];
};
