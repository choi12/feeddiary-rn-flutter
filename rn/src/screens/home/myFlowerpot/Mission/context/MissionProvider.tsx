import React, { PropsWithChildren, useMemo } from 'react';

import useMissions from '../hooks/useMissions';

import { MissionContext } from './MissionContext';

function MissionProvider({ children }: PropsWithChildren) {
  const {
    focusedMissions,
    refetch,
    isLoading,
    isError,
    count,
    tab,
    setTab,
    handleCompleteMission,
    isPendingCompleteMission,
  } = useMissions();

  const contextValue = useMemo(
    () => ({
      focusedMissions,
      refetch,
      isLoading,
      isError,
      count,
      tab,
      onSetTab: setTab,
      onCompleteMission: handleCompleteMission,
      isPendingCompleteMission,
    }),
    [focusedMissions, refetch, isLoading, isError, count, tab, setTab, handleCompleteMission, isPendingCompleteMission],
  );

  return <MissionContext.Provider value={contextValue}>{children}</MissionContext.Provider>;
}

export default MissionProvider;
