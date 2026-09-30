// useWriteDiary 훅 테스트 — 작성 시각을 실제 순간으로 보내 mock 왕복 후에도 같은 날짜로 남는지
import { act, renderHook } from '@testing-library/react-native';
import dayjs from 'dayjs';

import { APIGetDiary } from '@/api/diary/APIGetDiary';
import { setupMockAdapter } from '@/api/mock';
import useWriteDiary from '@/screens/home/myDiary/CreateDiary/hooks/useWriteDiary';

import { createQueryWrapper } from '@/test-utils/queryWrapper';

jest.mock('react-native-config', () => ({ __esModule: true, default: { USE_MOCK: 'true' } }));
jest.mock('react-native-image-picker', () => ({ launchImageLibrary: jest.fn() }));

const mockReplace = jest.fn();
jest.mock('@react-navigation/native', () => ({ useNavigation: () => ({ replace: mockReplace }) }));

describe('useWriteDiary', () => {
  beforeAll(() => setupMockAdapter());

  it('keeps a diary written at 16:30 local on the same local day after the round-trip', async () => {
    const writtenAt = dayjs('2026-05-20T16:30:00');
    const { result } = renderHook(() => useWriteDiary({}), { wrapper: createQueryWrapper().wrapper });

    act(() => result.current.handleSetDiaryState({ text: '오후 일기', date: writtenAt }));
    await act(async () => {
      await result.current.handleSubmitDiary();
    });

    const { diaryIdx } = mockReplace.mock.calls[0][1];
    const saved = await APIGetDiary({ diaryIdx });
    expect(saved.createdAt).toBe(writtenAt.toISOString());
    expect(dayjs(saved.createdAt).format('YYYY-MM-DD')).toBe('2026-05-20');
  });
});
