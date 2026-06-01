import React, { PropsWithChildren, useMemo } from 'react';

import useScrollStatus from '@/hooks/ui/interaction/useScrollStatus';

import useCommunitySort from '../hooks/useCommunitySort';

import { CommunityHeaderContext } from './CommunityHeaderContext';

function CommunityHeaderProvider({ children }: PropsWithChildren) {
  const { isScrolled, startScroll, endScroll } = useScrollStatus();
  const { sort, handleSetSortType } = useCommunitySort();

  const contextValue = useMemo(
    () => ({
      isScrolled,
      startScroll,
      endScroll,
      sort,
      onSetSortType: handleSetSortType,
    }),
    [isScrolled, startScroll, endScroll, sort, handleSetSortType],
  );

  return <CommunityHeaderContext.Provider value={contextValue}>{children}</CommunityHeaderContext.Provider>;
}
export default CommunityHeaderProvider;
