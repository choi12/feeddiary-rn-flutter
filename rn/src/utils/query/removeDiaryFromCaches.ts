// 일기 삭제 낙관 갱신 헬퍼 — 목록 캐시(커뮤니티·내 일기·월별)에서 일기를 빼고, 실패 시 되돌릴 스냅샷을 돌려준다
import { InfiniteData, QueryClient, QueryKey } from '@tanstack/react-query';

import { QUERY_KEYS } from '@/constants';

type DiaryItem = { idx: number };
export type QueriesSnapshot = [QueryKey, unknown][];

const INFINITE_LIST_KEYS = [QUERY_KEYS.COMMUNITY_DIARIES, QUERY_KEYS.DIARIES];
const LIST_KEYS = [...INFINITE_LIST_KEYS, QUERY_KEYS.MONTHLY_DIARIES];

export const removeDiaryFromCaches = async (queryClient: QueryClient, diaryIdx: number): Promise<QueriesSnapshot> => {
  await Promise.all(LIST_KEYS.map((key) => queryClient.cancelQueries({ queryKey: [key] })));

  const snapshot = LIST_KEYS.flatMap((key) => queryClient.getQueriesData({ queryKey: [key] }));

  INFINITE_LIST_KEYS.forEach((key) =>
    queryClient.setQueriesData<InfiniteData<DiaryItem[]>>({ queryKey: [key] }, (old) =>
      old ? { ...old, pages: old.pages.map((page) => page.filter((diary) => diary.idx !== diaryIdx)) } : old,
    ),
  );
  queryClient.setQueriesData<DiaryItem[]>({ queryKey: [QUERY_KEYS.MONTHLY_DIARIES] }, (old) =>
    old?.filter((diary) => diary.idx !== diaryIdx),
  );

  return snapshot;
};

export const restoreQueriesData = (queryClient: QueryClient, snapshot: QueriesSnapshot | undefined) => {
  snapshot?.forEach(([queryKey, data]) => queryClient.setQueryData(queryKey, data));
};
