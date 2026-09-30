// 삭제 확인 모달 연타 테스트 — 편지·일기·댓글 삭제 버튼을 빠르게 두 번 눌러도 API 가 한 번만 호출되는지
import { act, renderHook } from '@testing-library/react-native';
import React, { PropsWithChildren } from 'react';

import { APIDeleteComment } from '@/api/comment/APIDeleteComment';
import { CommunityDiaryDTO } from '@/api/community/types';
import { APIDeleteDiary } from '@/api/diary/APIDeleteDiary';
import { APIDeleteLetter } from '@/api/letter/APIDeleteLetter';
import { APIStatus } from '@/api/types';
import { QUERY_KEYS } from '@/constants';
import { CommentContext } from '@/screens/home/community/Comments/context/CommentContext';
import useDeleteComment from '@/screens/home/community/Comments/hooks/useDeleteComment';
import useDeleteLetter from '@/screens/home/letter/Letters/hooks/useDeleteLetter';
import useDiaryActions from '@/screens/home/myDiary/DiaryDetails/hooks/useDiaryActions';
import { useStore } from '@/store';
import { delay } from '@/utils/common/delay';

import { createQueryWrapper } from '@/test-utils/queryWrapper';

jest.mock('@/api/letter/APIDeleteLetter', () => ({ APIDeleteLetter: jest.fn() }));
jest.mock('@/api/diary/APIDeleteDiary', () => ({ APIDeleteDiary: jest.fn() }));
jest.mock('@/api/comment/APIDeleteComment', () => ({ APIDeleteComment: jest.fn() }));
jest.mock('@/components/common/VectorIcon', () => () => null);
jest.mock('@/utils/error/reportError', () => ({ reportError: jest.fn() }));
jest.mock('@react-navigation/native', () => ({ useNavigation: () => ({ goBack: jest.fn(), replace: jest.fn() }) }));

const mockDeleteLetter = APIDeleteLetter as jest.MockedFunction<typeof APIDeleteLetter>;
const mockDeleteDiary = APIDeleteDiary as jest.MockedFunction<typeof APIDeleteDiary>;
const mockDeleteComment = APIDeleteComment as jest.MockedFunction<typeof APIDeleteComment>;

// 두 번째 탭이 첫 요청 진행 중에 들어오도록, 테스트가 직접 끝낼 때까지 대기하는 응답
const pendingResponse = <T,>(value: T) => {
  let resolve: () => void = () => {};
  const promise = new Promise<T>((r) => {
    resolve = () => r(value);
  });
  return { promise, resolve };
};

// 삭제 후 토스트 전 delay(100) 까지 act 안에서 흘려보냄
const FLUSH_MS = 150;

const pressConfirmTwice = async (resolve: () => void) => {
  const confirm = useStore.getState().alert.content?.buttons[1];
  await act(async () => {
    confirm?.onPress();
    confirm?.onPress();
    resolve();
    await delay(FLUSH_MS);
  });
};

const DIARY = { idx: 10 } as CommunityDiaryDTO;

describe('delete confirm double tap', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('deletes a letter once', async () => {
    const { promise, resolve } = pendingResponse({ idx: 1, text: '', createdAt: '' });
    mockDeleteLetter.mockReturnValue(promise);
    const { result } = renderHook(() => useDeleteLetter(), { wrapper: createQueryWrapper().wrapper });

    act(() => result.current.handleOpenDeleteModal(1));
    await pressConfirmTwice(resolve);

    expect(mockDeleteLetter).toHaveBeenCalledTimes(1);
  });

  // 세 훅이 같은 try/catch/finally 가드를 쓰므로 편지 삭제 하나로 대표 — 실패 후 가드가 풀려 재시도할 수 있어야 한다
  it('releases the guard after a failed delete so the next press retries', async () => {
    mockDeleteLetter.mockRejectedValueOnce(new Error('delete failed'));
    mockDeleteLetter.mockResolvedValueOnce({ idx: 1, text: '', createdAt: '' });
    const { result } = renderHook(() => useDeleteLetter(), { wrapper: createQueryWrapper().wrapper });

    act(() => result.current.handleOpenDeleteModal(1));
    const confirm = useStore.getState().alert.content?.buttons[1];
    await act(async () => {
      confirm?.onPress();
      await delay(FLUSH_MS);
    });
    expect(mockDeleteLetter).toHaveBeenCalledTimes(1);

    await act(async () => {
      confirm?.onPress();
      await delay(FLUSH_MS);
    });
    expect(mockDeleteLetter).toHaveBeenCalledTimes(2);
  });

  it('deletes a diary once', async () => {
    const { promise, resolve } = pendingResponse<APIStatus>('success');
    mockDeleteDiary.mockReturnValue(promise);
    const { result } = renderHook(
      () => useDiaryActions({ diary: DIARY, isVisible: true, toggleVisibility: () => null }),
      { wrapper: createQueryWrapper().wrapper },
    );

    act(() => result.current.handleOpenDiaryActionModal());
    act(() => useStore.getState().bottomSheet.contentArr[2].onPress());
    await pressConfirmTwice(resolve);

    expect(mockDeleteDiary).toHaveBeenCalledTimes(1);
  });

  it('deletes a comment once', async () => {
    const { promise, resolve } = pendingResponse<APIStatus>('success');
    mockDeleteComment.mockReturnValue(promise);
    const { wrapper: QueryWrapper, queryClient } = createQueryWrapper();
    queryClient.setQueryData([QUERY_KEYS.COMMENTS, 10], []);
    const wrapper = ({ children }: PropsWithChildren) => (
      <QueryWrapper>
        <CommentContext.Provider
          value={{ comments: [], author: '', diaryIdx: 10, refetch: jest.fn(), isLoading: false, isError: false }}
        >
          {children}
        </CommentContext.Provider>
      </QueryWrapper>
    );
    const { result } = renderHook(() => useDeleteComment({ commentIdx: 1 }), { wrapper });

    act(() => result.current.handleOpenDeleteModal());
    await pressConfirmTwice(resolve);

    expect(mockDeleteComment).toHaveBeenCalledTimes(1);
  });
});
