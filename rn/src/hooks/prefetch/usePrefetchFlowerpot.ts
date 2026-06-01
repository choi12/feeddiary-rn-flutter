// 화분 프리페치 훅 — 메인 진입 전 화분 데이터를 미리 캐시에 적재
import { useQueryClient } from '@tanstack/react-query';
import { useCallback } from 'react';

import { APIGetFlowerpot } from '@/api/flowerpot/APIGetFlowerpot';
import { QUERY_KEYS } from '@/constants';
import { reportError } from '@/utils/error/reportError';

function usePrefetchFlowerpot() {
  const queryClient = useQueryClient();

  return useCallback(async () => {
    try {
      await queryClient.prefetchQuery({
        queryKey: [QUERY_KEYS.FLOWERPOT],
        queryFn: APIGetFlowerpot,
      });
    } catch (error) {
      reportError(error);
    }
  }, [queryClient]);
}

export default usePrefetchFlowerpot;
