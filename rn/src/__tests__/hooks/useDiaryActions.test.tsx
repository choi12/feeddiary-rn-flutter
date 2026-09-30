// useDiaryActions 삭제 테스트 — 삭제 성공 시 목록 캐시에서 즉시 빠지고, 실패 시 원래대로 복구되는지
import { useInfiniteQuery } from '@tanstack/react-query';
import { act, renderHook } from '@testing-library/react-native';

import { CommunityDiaryDTO } from '@/api/community/types';
import { APIDeleteDiary } from '@/api/diary/APIDeleteDiary';
import { DailyDiaryDTO, MyDiaryDTO } from '@/api/diary/types';
import { QUERY_KEYS } from '@/constants';
import useDiaryActions from '@/screens/home/myDiary/DiaryDetails/hooks/useDiaryActions';
import { useStore } from '@/store';
import { delay } from '@/utils/common/delay';

import { createQueryWrapper } from '@/test-utils/queryWrapper';

jest.mock('@/api/diary/APIDeleteDiary', () => ({ APIDeleteDiary: jest.fn() }));
jest.mock('@/components/common/VectorIcon', () => () => null);
jest.mock('@/utils/error/reportError', () => ({ reportError: jest.fn() }));
jest.mock('@react-navigation/native', () => ({ useNavigation: () => ({ goBack: jest.fn(), replace: jest.fn() }) }));

const mockDeleteDiary = APIDeleteDiary as jest.MockedFunction<typeof APIDeleteDiary>;

const DIARY_IDX = 10;
const COMMUNITY_KEY = [QUERY_KEYS.COMMUNITY_DIARIES, 'latest'];
const MY_DIARIES_KEY = [QUERY_KEYS.DIARIES];
const MONTHLY_KEY = [QUERY_KEYS.MONTHLY_DIARIES, '2026-05'];

const community = (idx: number) => ({ idx }) as CommunityDiaryDTO;
const COMMUNITY_DATA = { pages: [[community(1), community(2)], [community(DIARY_IDX), community(3)]], pageParams: [0, 10] };
const MY_DIARIES_DATA = { pages: [[{ idx: DIARY_IDX } as MyDiaryDTO, { idx: 4 } as MyDiaryDTO]], pageParams: [0] };
const MONTHLY_DATA = [{ idx: DIARY_IDX } as DailyDiaryDTO, { idx: 5 } as DailyDiaryDTO];

// 커뮤니티 목록을 구독 중인 상태를 흉내 — invalidate 뒤 refetch 가 끝나지 않고 대기하도록 한다
const pendingCommunityFetch = jest.fn(() => new Promise<CommunityDiaryDTO[]>(() => {}));

const renderDiaryActions = () => {
  const { wrapper, queryClient } = createQueryWrapper();
  queryClient.setQueryData(COMMUNITY_KEY, COMMUNITY_DATA);
  queryClient.setQueryData(MY_DIARIES_KEY, MY_DIARIES_DATA);
  queryClient.setQueryData(MONTHLY_KEY, MONTHLY_DATA);
  const { result } = renderHook(
    () => {
      useInfiniteQuery({
        queryKey: COMMUNITY_KEY,
        queryFn: pendingCommunityFetch,
        initialPageParam: 0,
        getNextPageParam: () => undefined,
        staleTime: Infinity,
      });
      return useDiaryActions({ diary: community(DIARY_IDX), isVisible: true, toggleVisibility: () => null });
    },
    { wrapper },
  );
  return { result, queryClient };
};

const pressDelete = async (result: { current: ReturnType<typeof useDiaryActions> }) => {
  act(() => result.current.handleOpenDiaryActionModal());
  act(() => useStore.getState().bottomSheet.contentArr[2].onPress());
  const confirm = useStore.getState().alert.content?.buttons[1];
  await act(async () => {
    confirm?.onPress();
    await delay(50);
  });
};

const flatIdx = (data: { pages: { idx: number }[][] } | undefined) => data?.pages.flat().map((d) => d.idx);

describe('useDiaryActions — delete', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('removes the diary from list caches before the refetch resolves', async () => {
    mockDeleteDiary.mockResolvedValue('success');
    const { result, queryClient } = renderDiaryActions();

    await pressDelete(result);

    expect(pendingCommunityFetch).toHaveBeenCalled();
    expect(queryClient.getQueryState(COMMUNITY_KEY)?.fetchStatus).toBe('fetching');
    expect(flatIdx(queryClient.getQueryData(COMMUNITY_KEY))).toEqual([1, 2, 3]);
    expect(flatIdx(queryClient.getQueryData(MY_DIARIES_KEY))).toEqual([4]);
    expect(queryClient.getQueryData<DailyDiaryDTO[]>(MONTHLY_KEY)?.map((d) => d.idx)).toEqual([5]);
  });

  it('restores the list caches when the delete fails', async () => {
    mockDeleteDiary.mockRejectedValue(new Error('delete failed'));
    const { result, queryClient } = renderDiaryActions();

    await pressDelete(result);

    expect(queryClient.getQueryData(COMMUNITY_KEY)).toEqual(COMMUNITY_DATA);
    expect(queryClient.getQueryData(MY_DIARIES_KEY)).toEqual(MY_DIARIES_DATA);
    expect(queryClient.getQueryData(MONTHLY_KEY)).toEqual(MONTHLY_DATA);
  });
});
