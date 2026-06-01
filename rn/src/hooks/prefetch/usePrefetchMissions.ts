// 미션 프리페치 훅 — 미션 화면 진입 전 미션 목록을 미리 캐시에 적재
import { useQueryClient } from '@tanstack/react-query';
import { useCallback } from 'react';

import { APIGetMissions } from '@/api/mission/APIGetMissions';
import { QUERY_KEYS } from '@/constants';
import { reportError } from '@/utils/error/reportError';

function usePrefetchMissions() {
  const queryClient = useQueryClient();

  return useCallback(async () => {
    try {
      await queryClient.prefetchQuery({
        queryKey: [QUERY_KEYS.MISSIONS],
        queryFn: APIGetMissions,
      });
    } catch (error) {
      reportError(error);
    }
  }, [queryClient]);
}

export default usePrefetchMissions;
