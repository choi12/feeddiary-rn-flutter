import { useMemo } from 'react';

import { FLOWERPOT_CONFIG } from '@/constants';

import { useFlowerpotContext } from '../context/flowerpot/FlowerpotContext';

function useFlowerpotStats() {
  const { flowerpot } = useFlowerpotContext();

  const stats = useMemo(() => {
    const level = flowerpot?.level ?? FLOWERPOT_CONFIG.DEFAULT_LEVEL;
    const isMaxLevel = level >= FLOWERPOT_CONFIG.MAX_LEVEL;

    const exp = flowerpot?.exp ?? FLOWERPOT_CONFIG.DEFAULT_EXP;
    const maxExp = flowerpot?.maxExp ?? FLOWERPOT_CONFIG.DEFAULT_MAX_EXP;

    const wateringCount = flowerpot?.wateringCount ?? 0;
    const loveCount = flowerpot?.loveCount ?? 0;
    const showBadge = flowerpot?.showBadge ?? false;

    const canWater = !!flowerpot && level <= 2 && wateringCount >= 1;
    const canLove = !!flowerpot && level <= 2 && loveCount >= 1;

    return {
      level,
      isMaxLevel,
      exp,
      maxExp,
      wateringCount,
      loveCount,
      showBadge,
      canWater,
      canLove,
    };
  }, [flowerpot]);

  return { ...stats };
}

export default useFlowerpotStats;
