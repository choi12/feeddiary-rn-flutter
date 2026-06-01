// 일기 상세 프리페치 훅 — 작성/수정 직후 상세 화면 데이터를 미리 캐시에 적재
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
