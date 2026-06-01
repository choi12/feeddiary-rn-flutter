import { ImageRequireSource } from 'react-native';

import { Apple, Google } from '@/assets/images';
import { COLORS } from '@/constants';
import { SignInType } from '@/types/auth';

type SignInColorConfig = {
  background: string;
  text: string;
};

export const SIGN_IN_COLOR: Record<SignInType, SignInColorConfig> = {
  google: { background: COLORS.GRAYSCALE.WHITE, text: COLORS.GRAYSCALE.BLACK },
  apple: { background: COLORS.GRAYSCALE.DARK_BLACK, text: COLORS.GRAYSCALE.WHITE },
};

export const SIGN_IN_LABEL: Record<SignInType, string> = {
  google: 'Sign in with Google',
  apple: 'Sign in with Apple',
};

export const SIGN_IN_ICON: Record<SignInType, ImageRequireSource> = {
  google: Google,
  apple: Apple,
};
