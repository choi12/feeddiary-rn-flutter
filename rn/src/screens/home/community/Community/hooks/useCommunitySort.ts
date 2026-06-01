// 커뮤니티 정렬 훅 — 정렬 기준 상태 관리와 선택 시 바텀시트 닫기
import { useCallback, useState } from 'react';

import useBottomSheetModal from '@/hooks/store/useBottomSheetModal';
import { CommunitySort } from '@/types/community';

function useCommunitySort() {
  const [sort, setSort] = useState<CommunitySort>('latest');
  const { closeBottomSheetModal } = useBottomSheetModal();

  const handleSetSortType = useCallback(
    (nextSort: CommunitySort) => {
      setSort(nextSort);
      closeBottomSheetModal();
    },
    [closeBottomSheetModal],
  );

  return { sort, handleSetSortType };
}

export default useCommunitySort;
