import { create } from 'zustand';

import { createModalSlice } from './slices/modal/slice';
import { createUISlice } from './slices/ui/slice';
import { createUserSlice } from './slices/user/slice';
import { StoreState } from './types';

/**
 * 전역 상태 관리를 위한 zustand store
 * - 각 도메인별로 분리된 slice들을 하나의 store로 결합
 */
export const useStore = create<StoreState>()((...methods) => ({
  ...createModalSlice(...methods),
  ...createUISlice(...methods),
  ...createUserSlice(...methods),
}));
