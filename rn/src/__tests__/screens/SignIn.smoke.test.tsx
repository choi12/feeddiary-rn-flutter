// SignIn 화면 스모크 렌더 — provider/네이티브 모듈 mock 후 크래시 없이 렌더되는지 검증
import { render } from '@testing-library/react-native';
import React from 'react';

import SignIn from '@/screens/start/SignIn';

import { createQueryWrapper } from '@/test-utils/queryWrapper';

jest.mock('@react-navigation/native', () => ({
  useNavigation: () => ({ navigate: jest.fn(), goBack: jest.fn(), replace: jest.fn(), reset: jest.fn() }),
  useIsFocused: () => true,
  useFocusEffect: jest.fn(),
}));
jest.mock('expo-image', () => ({ Image: () => null }));
jest.mock('@/components/common/VectorIcon', () => () => null);
jest.mock('@/assets/images', () => new Proxy({ __esModule: true }, { get: (_t, key) => (key === '__esModule' ? true : 0) }));
jest.mock('@react-native-google-signin/google-signin', () => ({
  GoogleSignin: { configure: jest.fn(), signIn: jest.fn(), signOut: jest.fn() },
}));
jest.mock('@invertase/react-native-apple-authentication', () => ({
  __esModule: true,
  default: {
    isSupported: false,
    Operation: { LOGIN: 1 },
    Scope: { FULL_NAME: 1, EMAIL: 2 },
    performRequest: jest.fn(),
    getCredentialStateForUser: jest.fn(),
  },
  appleAuthAndroid: { configure: jest.fn(), signIn: jest.fn(), ResponseType: {}, Scope: {} },
}));

describe('SignIn screen (smoke)', () => {
  it('renders without crashing', () => {
    const { toJSON } = render(<SignIn />, { wrapper: createQueryWrapper().wrapper });
    expect(toJSON()).toBeTruthy();
  });
});
