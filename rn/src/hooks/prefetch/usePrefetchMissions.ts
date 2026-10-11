// 미션 프리페치 훅 — 미션 화면 진입 전 미션 목록을 미리 캐시에 적재
import { useQueryClient } from '@tanstack/react-query';
import { useCallback } from 'react';

import { APIGetMissions } from '@/api/mission/APIGetMissions';
import { QUERY_KEYS } from '@/constants';

function usePrefetchMissions() {
  const queryClient = useQueryClient();

  return useCallback(async () => {
    // prefetchQuery 는 실패해도 던지지 않는다 — 실패 보고는 App.tsx 의 QueryCache onError 가 맡는다
    await queryClient.prefetchQuery({
      queryKey: [QUERY_KEYS.MISSIONS],
      queryFn: APIGetMissions,
    });
  }, [queryClient]);
}

export default usePrefetchMissions;
