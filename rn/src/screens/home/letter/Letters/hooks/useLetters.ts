import { useInfiniteQuery } from '@tanstack/react-query';
import dayjs from 'dayjs';
import { useCallback, useMemo } from 'react';

import { APIGetLetters, APIGetLettersParams } from '@/api/letter/APIGetLetters';
import { LetterDTO } from '@/api/letter/types';
import { QUERY_KEYS, ITEMS_PER_PAGE } from '@/constants';
import { INDEPENDENT_QUERY_CONFIG } from '@/utils/config/query';

function useLetters() {
  const {
    isLoading,
    data: lettersData,
    fetchNextPage,
    isFetchingNextPage,
    hasNextPage,
    refetch,
    isError,
  } = useInfiniteQuery({
    ...INDEPENDENT_QUERY_CONFIG,
    queryKey: [QUERY_KEYS.LETTERS],
    queryFn: ({ pageParam = 0 }) => {
      console.log('pageParam', pageParam);
      const params: APIGetLettersParams = {
        skip: pageParam,
      };
      return APIGetLetters(params);
    },
    initialPageParam: 0,
    getNextPageParam: (lastPage, pages) =>
      lastPage && lastPage.length > 0 ? pages.length * ITEMS_PER_PAGE : undefined,
  });

  const letters: LetterDTO[] = useMemo(() => {
    return lettersData?.pages ? lettersData?.pages.flat().filter((letter) => letter !== undefined) : [];
  }, [lettersData]);

  const handleFetchNextPage = useCallback(() => {
    if (hasNextPage && !isFetchingNextPage) {
      fetchNextPage();
    }
  }, [hasNextPage, isFetchingNextPage, fetchNextPage]);

  const isTodayLetterWritten = useMemo(
    () => letters.length > 0 && dayjs(letters[0].createdAt).isSame(dayjs(), 'day'),
    [letters],
  );

  const hasLetter = useMemo(() => letters.length > 0, [letters]);

  return { letters, refetch, handleFetchNextPage, isLoading, isError, isTodayLetterWritten, hasLetter };
}

export default useLetters;
