// useDiaryDetails 훅 테스트 — 일기 조회·내 일기 판별·공개여부 토글 API 호출
import { act, renderHook, waitFor } from '@testing-library/react-native';

import { CommunityDiaryDTO } from '@/api/community/types';
import { APIGetDiary } from '@/api/diary/APIGetDiary';
import { APISetVisibility } from '@/api/diary/APISetVisibility';
import useDiaryDetails from '@/screens/home/myDiary/DiaryDetails/hooks/useDiaryDetails';
import { useStore } from '@/store';

import { createQueryWrapper } from '@/test-utils/queryWrapper';

jest.mock('@/api/diary/APIGetDiary', () => ({ APIGetDiary: jest.fn() }));
jest.mock('@/api/diary/APISetVisibility', () => ({ APISetVisibility: jest.fn() }));

const mockGet = APIGetDiary as jest.MockedFunction<typeof APIGetDiary>;
const mockSetVisibility = APISetVisibility as jest.MockedFunction<typeof APISetVisibility>;

const buildDiary = (overrides: Partial<CommunityDiaryDTO> = {}): CommunityDiaryDTO => ({
  idx: 10,
  userIdx: 100,
  nickname: 'demo',
  sticker: 'S',
  text: 't',
  image: undefined,
  createdAt: '2026-05-27',
  updatedAt: undefined,
  isVisible: 0,
  likeCount: 5,
  commentCount: 0,
  userImage: 'a.png',
  background: '#fff',
  character: 'Dog',
  isLike: false,
  ...overrides,
});

const setUserNickname = (nickname: string) =>
  act(() =>
    useStore.setState({
      user: {
        idx: 1,
        account: 'a',
        userId: 'u',
        nickname,
        image: '',
        background: '',
        character: '',
        type: 'google',
        createdAt: new Date('2026-01-01'),
        token: 't',
      },
    }),
  );

const renderDetails = () =>
  renderHook(() => useDiaryDetails({ diaryIdx: 10 }), { wrapper: createQueryWrapper().wrapper });

describe('useDiaryDetails', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    act(() => useStore.setState({ user: null }));
  });

  it('marks the diary as mine when the nickname matches the logged-in user', async () => {
    mockGet.mockResolvedValue(buildDiary({ nickname: 'demo' }));
    setUserNickname('demo');

    const { result } = renderDetails();
    await waitFor(() => expect(result.current.isLoading).toBe(false));

    expect(result.current.diary?.nickname).toBe('demo');
    expect(result.current.isMyDiary).toBe(true);
  });

  it('marks the diary as not mine when nicknames differ', async () => {
    mockGet.mockResolvedValue(buildDiary({ nickname: 'someone-else' }));
    setUserNickname('demo');

    const { result } = renderDetails();
    await waitFor(() => expect(result.current.isLoading).toBe(false));

    expect(result.current.isMyDiary).toBe(false);
  });

  it('toggles visibility via the API and returns the next value', async () => {
    mockGet.mockResolvedValue(buildDiary({ isVisible: 0 }));
    mockSetVisibility.mockResolvedValue({ isVisible: 1 });
    setUserNickname('demo');

    const { result } = renderDetails();
    await waitFor(() => expect(result.current.isLoading).toBe(false));

    let next: boolean | null = null;
    await act(async () => {
      next = result.current.toggleVisibility();
    });

    expect(next).toBe(true);
    expect(mockSetVisibility).toHaveBeenCalledWith({ diaryIdx: 10 });
  });
});
