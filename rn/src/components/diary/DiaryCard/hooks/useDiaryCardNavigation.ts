import { useCallback } from 'react';

import useScreenNavigation from '@/hooks/core/navigation/useScreenNavigation';
import usePrefetchNextDiary from '@/hooks/prefetch/usePrefetchNextDiary';

function useDiaryCardNavigation() {
  const navigation = useScreenNavigation();
  const prefetchNextDiary = usePrefetchNextDiary();

  return useCallback(
    async (diaryIdx: number) => {
      await prefetchNextDiary(diaryIdx);
      navigation.navigate('DiaryDetails', { diaryIdx });
    },
    [navigation, prefetchNextDiary],
  );
}

export default useDiaryCardNavigation;
