import { useQueryClient } from '@tanstack/react-query';
import { useCallback } from 'react';

import { APIGetDiary, APIGetDiaryParams } from '@/api/diary/APIGetDiary';
import { QUERY_KEYS } from '@/constants';
import { reportError } from '@/utils/error/reportError';

function usePrefetchNextDiary() {
  const queryClient = useQueryClient();

  return useCallback(
    async (diaryIdx: number) => {
      try {
        const params: APIGetDiaryParams = { diaryIdx };

        await queryClient.prefetchQuery({
          queryKey: [QUERY_KEYS.DIARY, diaryIdx],
          queryFn: () => APIGetDiary(params),
        });
      } catch (error) {
        reportError(error);
      }
    },
    [queryClient],
  );
}

export default usePrefetchNextDiary;
