import { useShallow } from 'zustand/shallow';

import { useStore } from '@/store';

function useAlertModal() {
  return useStore(
    useShallow((state) => ({
      openAlertModal: state.openAlertModal,
      closeAlertModal: state.closeAlertModal,
    })),
  );
}

export default useAlertModal;
