// useSignIn 훅 테스트 — 토큰 저장(Keychain) 실패 시에도 로딩이 닫히고 에러가 처리되는지
import { act, renderHook } from '@testing-library/react-native';

import { APIAutoSignIn } from '@/api/auth/APIAutoSignIn';
import { APISignIn } from '@/api/auth/APISignIn';
import { UserDTO } from '@/api/auth/types';
import useSignIn from '@/screens/start/SignIn/hooks/useSignIn';
import { useStore } from '@/store';
import { delay } from '@/utils/common/delay';
import { reportError } from '@/utils/error/reportError';
import { getAccessToken, setAccessToken } from '@/utils/storage/auth';

import { createQueryWrapper } from '@/test-utils/queryWrapper';

jest.mock('react-native-config', () => ({ __esModule: true, default: { USE_MOCK: 'true' } }));
jest.mock('@react-native-google-signin/google-signin', () => ({ GoogleSignin: { configure: jest.fn(), signIn: jest.fn() } }));
jest.mock('@invertase/react-native-apple-authentication', () => ({
  __esModule: true,
  default: { isSupported: false },
  appleAuthAndroid: {},
}));
jest.mock('@/api/auth/APISignIn', () => ({ APISignIn: jest.fn() }));
jest.mock('@/api/auth/APIAutoSignIn', () => ({ APIAutoSignIn: jest.fn() }));
jest.mock('@/utils/storage/auth', () => ({ getAccessToken: jest.fn(), setAccessToken: jest.fn() }));
jest.mock('@/utils/storage/lock', () => ({ getUseLock: () => false }));
jest.mock('@/utils/error/reportError', () => ({ reportError: jest.fn() }));

const mockReplace = jest.fn();
jest.mock('@react-navigation/native', () => ({
  useNavigation: () => ({ replace: mockReplace, navigate: jest.fn() }),
}));

const mockSignIn = APISignIn as jest.MockedFunction<typeof APISignIn>;
const mockAutoSignIn = APIAutoSignIn as jest.MockedFunction<typeof APIAutoSignIn>;
const mockSetAccessToken = setAccessToken as jest.MockedFunction<typeof setAccessToken>;
const mockGetAccessToken = getAccessToken as jest.MockedFunction<typeof getAccessToken>;

const USER: UserDTO = {
  idx: 1,
  account: 'demo@example.com',
  userId: 'mock_user_id',
  nickname: '새싹이',
  image: '',
  background: '#FFE4B5',
  character: 'Chick',
  type: 'google',
  createdAt: new Date('2026-01-01'),
  token: 'token',
};

const FLUSH_MS = 50;

const renderSignIn = () => renderHook(() => useSignIn(), { wrapper: createQueryWrapper().wrapper });

describe('useSignIn — Keychain write failure', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    act(() => useStore.setState({ loading: { isVisible: false }, toast: { isVisible: false, message: '', bottomOffset: 0 } }));
    mockSetAccessToken.mockRejectedValue(new Error('keychain unavailable'));
  });

  it('hides the loading and shows an error toast on sign-in', async () => {
    mockSignIn.mockResolvedValue(USER);
    const { result } = renderSignIn();

    act(() => result.current.handleSignIn('google'));
    expect(useStore.getState().loading.isVisible).toBe(true);

    // handleSignIn 은 결과를 기다리지 않으므로 로그인 체인이 끝날 때까지 act 안에서 흘려보냄
    await act(() => delay(FLUSH_MS));

    expect(useStore.getState().toast.isVisible).toBe(true);
    expect(useStore.getState().loading.isVisible).toBe(false);
    expect(mockReplace).not.toHaveBeenCalled();
  });

  it('falls back to the sign-in screen on auto sign-in', async () => {
    mockGetAccessToken.mockReturnValue('token');
    mockAutoSignIn.mockResolvedValue(USER);
    const { result } = renderSignIn();

    await act(async () => {
      await result.current.autoSignIn();
      await delay(FLUSH_MS);
    });

    expect(reportError).toHaveBeenCalled();
    expect(mockReplace).toHaveBeenCalledWith('SignIn');
  });
});
