// 화분 프리페치 훅 — 메인 진입 전 화분 데이터를 미리 캐시에 적재
import { useQueryClient } from '@tanstack/react-query';
import { useCallback } from 'react';

import { APIGetFlowerpot } from '@/api/flowerpot/APIGetFlowerpot';
import { QUERY_KEYS } from '@/constants';

function usePrefetchFlowerpot() {
  const queryClient = useQueryClient();

  return useCallback(async () => {
    // prefetchQuery 는 실패해도 던지지 않는다 — 실패 보고는 App.tsx 의 QueryCache onError 가 맡는다
    await queryClient.prefetchQuery({
      queryKey: [QUERY_KEYS.FLOWERPOT],
      queryFn: APIGetFlowerpot,
    });
  }, [queryClient]);
}

export default usePrefetchFlowerpot;
