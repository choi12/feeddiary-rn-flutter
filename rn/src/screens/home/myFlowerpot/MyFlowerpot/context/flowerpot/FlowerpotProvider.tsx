import React, { PropsWithChildren, useMemo } from 'react';

import useFlowerpotQuery from '../../hooks/useFlowerpotQuery';

import { FlowerpotContext } from './FlowerpotContext';

function FlowerpotProvider({ children }: PropsWithChildren) {
  const { data: flowerpot, refetch, isLoading, isError } = useFlowerpotQuery();

  const contextValue = useMemo(
    () => ({ flowerpot, refetch, isLoading, isError }),
    [flowerpot, refetch, isLoading, isError],
  );

  return <FlowerpotContext.Provider value={contextValue}>{children}</FlowerpotContext.Provider>;
}

export default FlowerpotProvider;
