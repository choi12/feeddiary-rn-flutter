import { QueryObserverResult } from '@tanstack/react-query';

import { FlowerpotDTO } from '@/api/flowerpot/types';
import useTypedContext from '@/hooks/core/context/useTypedContext';
import { createNamedContext } from '@/utils/context/createNamedContext';

type FlowerpotContext = {
  flowerpot: FlowerpotDTO | undefined;

  refetch: () => Promise<QueryObserverResult<FlowerpotDTO, Error>>;
  isLoading: boolean;
  isError: boolean;
};

export const FlowerpotContext = createNamedContext<FlowerpotContext | undefined>('FlowerpotContext', undefined);
export const useFlowerpotContext = () => useTypedContext(FlowerpotContext);
