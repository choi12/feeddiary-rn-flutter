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
