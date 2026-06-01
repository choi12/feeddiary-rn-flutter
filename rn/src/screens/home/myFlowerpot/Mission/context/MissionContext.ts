import { QueryObserverResult } from '@tanstack/react-query';

import { MissionDTO, MissionsDTO } from '@/api/mission/types';
import useTypedContext from '@/hooks/core/context/useTypedContext';
import { Mission } from '@/types/mission';
import { createNamedContext } from '@/utils/context/createNamedContext';

import { MissionCount, MissionTab } from '../types';

type MissionContext = {
  focusedMissions: MissionDTO[];
  count: MissionCount;

  refetch: () => Promise<QueryObserverResult<MissionsDTO, Error>>;
  isLoading: boolean;
  isError: boolean;

  tab: MissionTab;
  onSetTab: (tab: MissionTab) => void;

  onCompleteMission: (missionIdx: number, type: Mission) => Promise<void>;
  isPendingCompleteMission: boolean;
};

export const MissionContext = createNamedContext<MissionContext | undefined>('MissionContext', undefined);
export const useMissionContext = () => useTypedContext(MissionContext);
