// 일기 상세 프리페치 훅 — 작성/수정 직후 상세 화면 데이터를 미리 캐시에 적재
import { useQueryClient } from '@tanstack/react-query';
import { useCallback } from 'react';

import { APIGetDiary, APIGetDiaryParams } from '@/api/diary/APIGetDiary';
import { QUERY_KEYS } from '@/constants';

function usePrefetchNextDiary() {
  const queryClient = useQueryClient();

  return useCallback(
    async (diaryIdx: number) => {
      const params: APIGetDiaryParams = { diaryIdx };

      // prefetchQuery 는 실패해도 던지지 않는다 — 실패 보고는 App.tsx 의 QueryCache onError 가 맡는다
      await queryClient.prefetchQuery({
        queryKey: [QUERY_KEYS.DIARY, diaryIdx],
        queryFn: () => APIGetDiary(params),
      });
    },
    [queryClient],
  );
}

export default usePrefetchNextDiary;
