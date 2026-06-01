import { StateCreator } from 'zustand';

import { UISlice } from './types';

export const createUISlice: StateCreator<UISlice> = (set) => ({
  loading: {
    isVisible: false,
  },
  toast: {
    isVisible: false,
    message: '',
    bottomOffset: 0,
  },
  showLoading: () =>
    set(() => ({
      loading: { isVisible: true },
    })),
  hideLoading: () =>
    set(() => ({
      loading: { isVisible: false },
    })),
  showToast: (message, bottomOffset) =>
    set((state) => ({
      toast: { ...state.toast, message, bottomOffset, isVisible: true },
    })),
  hideToast: () =>
    set((state) => ({
      toast: { ...state.toast, message: '', isVisible: false },
    })),
});
