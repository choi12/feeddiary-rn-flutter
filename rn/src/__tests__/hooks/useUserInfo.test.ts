// useUserInfo 훅 테스트 — 단일/배열 selector 오버로드와 비로그인 상태 분기
import { act, renderHook } from '@testing-library/react-native';

import { UserDTO } from '@/api/auth/types';
import useUserInfo from '@/hooks/store/useUserInfo';
import { useStore } from '@/store';

const mockUser: UserDTO = {
  idx: 1,
  userId: 'u1',
  account: 'demo@example.com',
  nickname: 'demo',
  token: 't',
  type: 'google',
  image: 'img.png',
  background: '#fff',
  character: 'Dog',
  createdAt: new Date('2026-01-01'),
};

describe('useUserInfo', () => {
  afterEach(() => act(() => useStore.setState({ user: null })));

  it('returns a single field value for a string selector', () => {
    act(() => useStore.setState({ user: mockUser }));
    const { result } = renderHook(() => useUserInfo('nickname'));
    expect(result.current).toBe('demo');
  });

  it('returns an object of fields for an array selector', () => {
    act(() => useStore.setState({ user: mockUser }));
    const { result } = renderHook(() => useUserInfo(['nickname', 'account']));
    expect(result.current).toEqual({ nickname: 'demo', account: 'demo@example.com' });
  });

  it('returns undefined when there is no user', () => {
    act(() => useStore.setState({ user: null }));
    const { result } = renderHook(() => useUserInfo('nickname'));
    expect(result.current).toBeUndefined();
  });
});
