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
