import { ReactNode } from 'react';

type ModalButtonStyle = 'default' | 'cancel';

type ModalButton = {
  text: string;
  onPress: () => void;
  style: ModalButtonStyle;
  isLoading?: boolean;
};

type MaxTwoArray<T> = [T] | [T, T];

export type AlertModalContent = {
  message: string;
  image?: ReactNode;
  buttons: MaxTwoArray<ModalButton>;
  onPressBackground?: () => void;
};

export type BottomSheetModalContent = {
  title: string;
  icon?: ReactNode;
  color: string;
  onPress: () => void;
};
