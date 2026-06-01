// 커뮤니티 일기 목록 훅 — 정렬별 무한스크롤 조회와 앱 포그라운드 복귀 시 재조회
import { useInfiniteQuery } from '@tanstack/react-query';
import { useCallback, useEffect, useMemo } from 'react';
import { AppState, AppStateStatus } from 'react-native';

import { APIGetCommunityDiaries, APIGetCommunityDiariesParams } from '@/api/community/APIGetCommunityDiaries';
import { CommunityDiaryDTO } from '@/api/community/types';
import { QUERY_KEYS, ITEMS_PER_PAGE } from '@/constants';
import { REALTIME_QUERY_CONFIG } from '@/utils/config/query';

import { useCommunityHeaderContext } from '../context/CommunityHeaderContext';

function useCommunityDiaries() {
  const { sort } = useCommunityHeaderContext();

  const {
    isLoading,
    data: communityDiariesData,
    fetchNextPage,
    isFetchingNextPage,
    hasNextPage,
    refetch,
    isError,
  } = useInfiniteQuery({
    ...REALTIME_QUERY_CONFIG,
    queryKey: [QUERY_KEYS.COMMUNITY_DIARIES, sort],
    queryFn: ({ pageParam = 0 }) => {
      const params: APIGetCommunityDiariesParams = {
        skip: pageParam,
        sortType: sort,
      };
      return APIGetCommunityDiaries(params);
    },
    initialPageParam: 0,
    getNextPageParam: (lastPage, pages) =>
      lastPage && lastPage.length > 0 ? pages.length * ITEMS_PER_PAGE : undefined,
  });

  const communityDiaries: CommunityDiaryDTO[] = useMemo(() => {
    return communityDiariesData?.pages
      ? communityDiariesData?.pages.flat().filter((communityDiary) => communityDiary !== undefined)
      : [];
  }, [communityDiariesData]);

  const handleFetchNextPage = useCallback(() => {
    if (hasNextPage && !isFetchingNextPage) {
      fetchNextPage();
    }
  }, [hasNextPage, isFetchingNextPage, fetchNextPage]);

  useEffect(() => {
    const subscription = AppState.addEventListener('change', (nextAppState: AppStateStatus) => {
      if (nextAppState === 'active') {
        refetch();
      }
    });

    return () => subscription.remove();
  }, [refetch]);

  return { communityDiaries, refetch, handleFetchNextPage, isLoading, isError };
}

export default useCommunityDiaries;
