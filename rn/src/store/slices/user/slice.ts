// 로그인 사용자 정보 slice — 저장/삭제 시 Sentry user 컨텍스트 동기화
import * as Sentry from '@sentry/react-native';
import { StateCreator } from 'zustand';

import { UserDTO } from '@/api/auth/types';

import { UserSlice } from './types';

export const createUserSlice: StateCreator<UserSlice> = (set) => ({
  user: null,
  saveUser: (data: UserDTO) =>
    set((state) => {
      const updatedUser = state.user ? { ...state.user, ...data } : data;

      Sentry.setUser({
        id: updatedUser.userId,
        nickname: updatedUser.nickname,
        account: updatedUser.account,
      });

      return { user: updatedUser };
    }),

  removeUser: () => {
    set(() => {
      Sentry.setUser(null);

      return { user: null };
    });
  },
});
