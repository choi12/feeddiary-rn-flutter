import { useShallow } from 'zustand/shallow';

import { useStore } from '@/store';

function useLoading() {
  return useStore(
    useShallow((state) => ({
      showLoading: state.showLoading,
      hideLoading: state.hideLoading,
    })),
  );
}

export default useLoading;
