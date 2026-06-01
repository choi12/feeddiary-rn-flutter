// MyDiary 화면 스모크 렌더 — provider 래핑 후 크래시 없이 렌더되는지 검증
import { render } from '@testing-library/react-native';
import React from 'react';

import MyDiary from '@/screens/home/myDiary/MyDiary';

import { createQueryWrapper } from '@/test-utils/queryWrapper';

jest.mock('@react-navigation/native', () => ({
  useNavigation: () => ({ navigate: jest.fn(), goBack: jest.fn(), replace: jest.fn() }),
  useFocusEffect: jest.fn(),
}));
jest.mock('expo-image', () => ({ Image: () => null }));
jest.mock('@/components/common/VectorIcon', () => () => null);
jest.mock('@/assets/images', () => new Proxy({ __esModule: true }, { get: (_t, key) => (key === '__esModule' ? true : 0) }));
jest.mock('@/api/diary/APIGetDiaries', () => ({ APIGetDiaries: jest.fn().mockResolvedValue([]) }));
jest.mock('@/api/diary/APIGetMonthlyDiaries', () => ({ APIGetMonthlyDiaries: jest.fn().mockResolvedValue([]) }));

describe('MyDiary screen (smoke)', () => {
  it('renders without crashing', () => {
    const { toJSON } = render(<MyDiary />, { wrapper: createQueryWrapper().wrapper });
    expect(toJSON()).toBeTruthy();
  });
});
