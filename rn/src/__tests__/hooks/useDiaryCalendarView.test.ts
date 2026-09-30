// useDiaryCalendarView 훅 테스트 — 월을 바꾸면 이전 달 일기를 보여주지 않고 해당 달을 조회하는지
import { act, renderHook, waitFor } from '@testing-library/react-native';
import dayjs from 'dayjs';

import { APIGetMonthlyDiaries } from '@/api/diary/APIGetMonthlyDiaries';
import { DailyDiaryDTO } from '@/api/diary/types';
import useDiaryCalendarView from '@/screens/home/myDiary/MyDiary/hooks/useDiaryCalendarView';
import { invalidateQueries } from '@/utils/query/invalidateQueries';

import { createQueryWrapper } from '@/test-utils/queryWrapper';

jest.mock('@/api/diary/APIGetMonthlyDiaries', () => ({ APIGetMonthlyDiaries: jest.fn() }));

const mockGetMonthly = APIGetMonthlyDiaries as jest.MockedFunction<typeof APIGetMonthlyDiaries>;

const buildDaily = (idx: number, createdAt: string): DailyDiaryDTO => ({
  idx,
  sticker: 'Star',
  text: 't',
  image: undefined,
  createdAt,
  updatedAt: undefined,
  isVisible: 1,
});

const DIARIES_BY_MONTH: Record<string, DailyDiaryDTO[]> = {
  '2026-05': [buildDaily(1, '2026-05-10T03:00:00.000Z')],
  '2026-04': [buildDaily(2, '2026-04-10T03:00:00.000Z')],
};

describe('useDiaryCalendarView', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    mockGetMonthly.mockImplementation(async ({ month }) => DIARIES_BY_MONTH[month] ?? []);
  });

  it('keeps the calendar mounted without the previous month\'s diaries while switching month', async () => {
    const { result } = renderHook(() => useDiaryCalendarView(), { wrapper: createQueryWrapper().wrapper });

    await waitFor(() => expect(result.current.isLoading).toBe(false));

    act(() => result.current.setSelectedMonth(dayjs('2026-05-01')));
    await waitFor(() => expect(result.current.monthlyDiaries.map((d) => d.idx)).toEqual([1]));

    act(() => result.current.setSelectedMonth(dayjs('2026-04-01')));
    // 새 달 로딩 중에도 달력은 유지(isLoading false)하되, 이전 달 일기 목록은 보여주지 않는다
    expect(result.current.isLoading).toBe(false);
    expect(result.current.dailyDiaries).toEqual([]);

    await waitFor(() => expect(result.current.monthlyDiaries.map((d) => d.idx)).toEqual([2]));
    expect(result.current.dailyDiaries.map((d) => d.idx)).toEqual([2]);
    expect(mockGetMonthly).toHaveBeenLastCalledWith({ month: '2026-04' });
  });

  it('refetches the current month when the diaries group is invalidated', async () => {
    const { wrapper, queryClient } = createQueryWrapper();
    const { result } = renderHook(() => useDiaryCalendarView(), { wrapper });
    await waitFor(() => expect(result.current.isLoading).toBe(false));

    act(() => result.current.setSelectedMonth(dayjs('2026-05-01')));
    await waitFor(() => expect(result.current.monthlyDiaries.map((d) => d.idx)).toEqual([1]));
    mockGetMonthly.mockClear();

    await act(async () => invalidateQueries.deleteDiary(queryClient));

    expect(mockGetMonthly).toHaveBeenCalledWith({ month: '2026-05' });
  });
});
