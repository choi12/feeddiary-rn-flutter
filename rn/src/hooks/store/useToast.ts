import { useShallow } from 'zustand/shallow';

import { useStore } from '@/store';

function useToast() {
  return useStore(
    useShallow((state) => ({
      showToast: state.showToast,
      hideToast: state.hideToast,
    })),
  );
}

export default useToast;
