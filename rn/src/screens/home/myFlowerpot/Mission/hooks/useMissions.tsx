import { useQuery } from '@tanstack/react-query';
import { useEffect, useMemo, useState } from 'react';

import { APIGetMissions } from '@/api/mission/APIGetMissions';
import { QUERY_KEYS } from '@/constants';
import { INDEPENDENT_QUERY_CONFIG } from '@/utils/config/query';

import { MissionTab, TABS } from '../types';

import useCompleteMission from './useCompleteMission';

function useMissions() {
  const [tab, setTab] = useState<MissionTab>(TABS.IN_PROGRESS);

  const {
    data: missionData,
    refetch,
    isLoading,
    isError,
  } = useQuery({
    ...INDEPENDENT_QUERY_CONFIG,
    queryKey: [QUERY_KEYS.MISSIONS],
    queryFn: async () => {
      const response = await APIGetMissions();
      return response;
    },
  });

  const completedMissions = useMemo(() => (missionData ? missionData.completed : []), [missionData]);
  const inProgressMissions = useMemo(() => (missionData ? missionData.inProgress : []), [missionData]);

  const missions = useMemo(
    () => ({
      [TABS.IN_PROGRESS]: inProgressMissions,
      [TABS.COMPLETED]: completedMissions,
    }),
    [inProgressMissions, completedMissions],
  );

  const count = useMemo(
    () => ({
      [TABS.IN_PROGRESS]: inProgressMissions.length,
      [TABS.COMPLETED]: completedMissions.length,
    }),
    [inProgressMissions, completedMissions],
  );

  const { handleCompleteMission, isPending: isPendingCompleteMission } = useCompleteMission();

  useEffect(() => {
    if (missionData && missionData.inProgress.length < 1) {
      setTab(TABS.COMPLETED);
    }
  }, [missionData]);

  return {
    focusedMissions: missions[tab],
    refetch,
    isLoading,
    isError,
    count,
    tab,
    setTab,
    handleCompleteMission,
    isPendingCompleteMission,
  };
}

export default useMissions;
