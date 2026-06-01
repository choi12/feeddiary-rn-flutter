// useLikeDiary 훅 테스트 — 초기 좋아요 상태, 내 일기 차단, 좋아요 API 호출
import { act, renderHook } from '@testing-library/react-native';

import { CommunityDiaryDTO } from '@/api/community/types';
import { APILikeDiary } from '@/api/diary/APILikeDiary';
import useLikeDiary from '@/screens/home/myDiary/DiaryDetails/hooks/useLikeDiary';
import { useStore } from '@/store';

import { createQueryWrapper } from '@/test-utils/queryWrapper';

jest.mock('@/api/diary/APILikeDiary', () => ({ APILikeDiary: jest.fn() }));

const mockLike = APILikeDiary as jest.MockedFunction<typeof APILikeDiary>;

const buildDiary = (overrides: Partial<CommunityDiaryDTO> = {}): CommunityDiaryDTO => ({
  idx: 10,
  userIdx: 100,
  nickname: 'author',
  sticker: 'S',
  text: 't',
  image: undefined,
  createdAt: '2026-05-27',
  updatedAt: undefined,
  isVisible: 1,
  likeCount: 5,
  commentCount: 0,
  userImage: 'a.png',
  background: '#fff',
  character: 'Dog',
  isLike: false,
  ...overrides,
});

const renderLike = (props: { diary: CommunityDiaryDTO; isMyDiary: boolean }) =>
  renderHook(() => useLikeDiary(props), { wrapper: createQueryWrapper().wrapper });

describe('useLikeDiary', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    act(() => useStore.setState({ toast: { isVisible: false, message: '', bottomOffset: 0 } }));
  });

  it('exposes the initial like state from the diary', () => {
    const { result } = renderLike({ diary: buildDiary({ isLike: false, likeCount: 5 }), isMyDiary: false });
    expect(result.current.isLiked).toBe(false);
    expect(result.current.likeCount).toBe(5);
  });

  it('blocks liking your own diary and shows a toast instead', () => {
    const { result } = renderLike({ diary: buildDiary(), isMyDiary: true });

    act(() => result.current.handleLike());

    expect(mockLike).not.toHaveBeenCalled();
    expect(useStore.getState().toast.isVisible).toBe(true);
  });

  it('calls the like API for another user\'s diary', async () => {
    mockLike.mockResolvedValue({ isLike: false, likeCount: 5 });
    const { result } = renderLike({ diary: buildDiary({ idx: 10 }), isMyDiary: false });

    await act(async () => {
      result.current.handleLike();
    });

    expect(mockLike).toHaveBeenCalledWith({ diaryIdx: 10 });
  });
});
