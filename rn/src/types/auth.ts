export type SignInType = 'google' | 'apple';

export type SignInParams = {
  uid: string;
  email: string;
  type: SignInType;
};

export type SettingPasswordStep = 1 | 2;
