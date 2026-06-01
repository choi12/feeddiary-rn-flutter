import { StateCreator } from 'zustand';

import { ModalSlice } from './types';

export const createModalSlice: StateCreator<ModalSlice> = (set) => ({
  alert: {
    isVisible: false,
    content: null,
  },
  bottomSheet: {
    isVisible: false,
    contentArr: [],
  },
  openAlertModal: (data) =>
    set((state) => ({
      alert: { ...state.alert, content: data, isVisible: true },
    })),
  closeAlertModal: () =>
    set((state) => ({
      alert: { ...state.alert, content: null, isVisible: false },
    })),
  openBottomSheetModal: (data) =>
    set((state) => ({
      bottomSheet: { ...state.bottomSheet, contentArr: data, isVisible: true },
    })),
  closeBottomSheetModal: () =>
    set((state) => ({
      bottomSheet: { ...state.bottomSheet, contentArr: [], isVisible: false },
    })),
});
