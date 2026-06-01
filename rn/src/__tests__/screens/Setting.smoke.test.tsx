// Setting 화면 스모크 렌더 — provider 래핑 후 헤더가 그려지는지(크래시 없음) 검증
import { render, screen } from '@testing-library/react-native';
import React from 'react';

import Setting from '@/screens/home/setting/Setting';
import { useStore } from '@/store';

import { createQueryWrapper } from '@/test-utils/queryWrapper';

jest.mock('@react-navigation/native', () => ({
  useNavigation: () => ({ navigate: jest.fn(), goBack: jest.fn(), replace: jest.fn(), reset: jest.fn() }),
  useFocusEffect: jest.fn(),
}));
jest.mock('expo-image', () => ({ Image: () => null }));
jest.mock('@/components/common/VectorIcon', () => () => null);
jest.mock('@react-native-google-signin/google-signin', () => ({
  GoogleSignin: { configure: jest.fn(), signIn: jest.fn(), signOut: jest.fn() },
}));
jest.mock('@/assets/images', () => new Proxy({ __esModule: true }, { get: (_t, key) => (key === '__esModule' ? true : 0) }));

describe('Setting screen (smoke)', () => {
  it('renders the settings screen without crashing', () => {
    useStore.setState({
      user: {
        idx: 1,
        account: 'demo@example.com',
        userId: 'u',
        nickname: 'demo',
        image: '',
        background: '',
        character: '',
        type: 'google',
        createdAt: new Date('2026-01-01'),
        token: 't',
      },
    });

    render(<Setting />, { wrapper: createQueryWrapper().wrapper });

    expect(screen.getByText('설정')).toBeTruthy();
  });
});
