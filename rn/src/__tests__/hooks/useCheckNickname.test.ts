// useCheckNickname 훅 테스트 — debounce 후 정규식·중복·동일닉네임 분기 검증
import { act, renderHook } from '@testing-library/react-native';

import { APICheckNickname } from '@/api/auth/APICheckNickname';
import useCheckNickname from '@/hooks/features/profile/useCheckNickname';
import { useStore } from '@/store';
import { ConflictError } from '@/types/errors';

import { createQueryWrapper } from '@/test-utils/queryWrapper';

jest.mock('@/api/auth/APICheckNickname', () => ({ APICheckNickname: jest.fn() }));

const mockCheck = APICheckNickname as jest.MockedFunction<typeof APICheckNickname>;

const flushDebounce = async () => {
  await act(async () => {
    jest.advanceTimersByTime(300);
  });
};

describe('useCheckNickname', () => {
  beforeEach(() => {
    jest.useFakeTimers();
    jest.clearAllMocks();
    act(() => useStore.setState({ user: null }));
  });
  afterEach(() => jest.useRealTimers());

  it('sets "success" when a valid nickname passes the duplication check', async () => {
    mockCheck.mockResolvedValue('success');
    const { result } = renderHook(() => useCheckNickname(), { wrapper: createQueryWrapper().wrapper });

    act(() => result.current.setNickname('hello'));
    await flushDebounce();

    expect(mockCheck).toHaveBeenCalledWith({ nickname: 'hello' });
    expect(result.current.notiType).toBe('success');
  });

  it('sets "regex" for an invalid nickname without calling the API', async () => {
    const { result } = renderHook(() => useCheckNickname(), { wrapper: createQueryWrapper().wrapper });

    act(() => result.current.setNickname('!'));
    await flushDebounce();

    expect(mockCheck).not.toHaveBeenCalled();
    expect(result.current.notiType).toBe('regex');
  });

  it('sets "duplicate" when the API throws ConflictError', async () => {
    mockCheck.mockRejectedValue(new ConflictError());
    const { result } = renderHook(() => useCheckNickname(), { wrapper: createQueryWrapper().wrapper });

    act(() => result.current.setNickname('taken'));
    await flushDebounce();

    expect(result.current.notiType).toBe('duplicate');
  });

  it('leaves notiType undefined when the nickname matches the current one', async () => {
    act(() =>
      useStore.setState({
        user: {
          idx: 1,
          account: 'a',
          userId: 'u',
          nickname: 'demo',
          image: '',
          background: '',
          character: '',
          type: 'google',
          createdAt: new Date('2026-01-01'),
          token: 't',
        },
      }),
    );
    const { result } = renderHook(() => useCheckNickname(), { wrapper: createQueryWrapper().wrapper });

    act(() => result.current.setNickname('DEMO'));
    await flushDebounce();

    expect(mockCheck).not.toHaveBeenCalled();
    expect(result.current.notiType).toBeUndefined();
  });
});
