// 화분 조회 훅 — 화분 상태(레벨·경험치·물주기/사랑 횟수)를 조회
import { useQuery } from '@tanstack/react-query';

import { APIGetFlowerpot } from '@/api/flowerpot/APIGetFlowerpot';
import { QUERY_KEYS } from '@/constants';
import { INDEPENDENT_QUERY_CONFIG } from '@/utils/config/query';

function useFlowerpotQuery() {
  return useQuery({
    ...INDEPENDENT_QUERY_CONFIG,
    queryKey: [QUERY_KEYS.FLOWERPOT],
    queryFn: APIGetFlowerpot,
  });
}

export default useFlowerpotQuery;
