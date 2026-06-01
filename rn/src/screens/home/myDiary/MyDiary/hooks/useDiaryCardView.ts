import { useInfiniteQuery } from '@tanstack/react-query';
import { useCallback, useMemo } from 'react';

import { APIGetDiaries, APIGetDiariesParams } from '@/api/diary/APIGetDiaries';
import { MyDiaryDTO } from '@/api/diary/types';
import { ITEMS_PER_PAGE, QUERY_KEYS } from '@/constants';
import useScrollStatus from '@/hooks/ui/interaction/useScrollStatus';
import { INDEPENDENT_QUERY_CONFIG } from '@/utils/config/query';

import { CardListProps } from '../components/CardList';

function useDiaryCardView(): CardListProps {
  const { isScrolled, startScroll, endScroll } = useScrollStatus();

  const {
    data: diaryData,
    fetchNextPage,
    isFetchingNextPage,
    hasNextPage,
    refetch,
    isLoading,
    isError,
  } = useInfiniteQuery({
    ...INDEPENDENT_QUERY_CONFIG,
    queryKey: [QUERY_KEYS.DIARIES],
    queryFn: ({ pageParam = 0 }) => {
      console.log('pageParam', pageParam);
      const params: APIGetDiariesParams = {
        skip: pageParam,
      };
      return APIGetDiaries(params);
    },
    initialPageParam: 0,
    getNextPageParam: (lastPage, pages) =>
      lastPage && lastPage.length > 0 ? pages.length * ITEMS_PER_PAGE : undefined,
  });

  const diaries: MyDiaryDTO[] = useMemo(() => {
    return (diaryData?.pages ? diaryData?.pages.flat() : []) as MyDiaryDTO[];
  }, [diaryData]);

  const handleFetchNextPage = useCallback(() => {
    if (hasNextPage && !isFetchingNextPage) {
      fetchNextPage();
    }
  }, [hasNextPage, isFetchingNextPage, fetchNextPage]);

  return {
    diaries,
    refetch,
    onFetchNextPage: handleFetchNextPage,
    isScrolled,
    startScroll,
    endScroll,
    isLoading,
    isError,
  };
}

export default useDiaryCardView;
