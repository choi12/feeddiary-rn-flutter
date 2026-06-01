import { useCallback, useState } from 'react';

import useBottomSheetModal from '@/hooks/store/useBottomSheetModal';
import { CommunitySort } from '@/types/community';

function useCommunitySort() {
  const [sort, setSort] = useState<CommunitySort>('latest');
  const { closeBottomSheetModal } = useBottomSheetModal();

  const handleSetSortType = useCallback(
    (sort: CommunitySort) => {
      setSort(sort);
      closeBottomSheetModal();
    },
    [closeBottomSheetModal],
  );

  return { sort, handleSetSortType };
}

export default useCommunitySort;
