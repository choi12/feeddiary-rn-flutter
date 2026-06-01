import { useShallow } from 'zustand/shallow';

import { useStore } from '@/store';

function useBottomSheetModal() {
  return useStore(
    useShallow((state) => ({
      openBottomSheetModal: state.openBottomSheetModal,
      closeBottomSheetModal: state.closeBottomSheetModal,
    })),
  );
}

export default useBottomSheetModal;
