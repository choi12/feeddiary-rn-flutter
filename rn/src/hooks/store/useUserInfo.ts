import { useShallow } from 'zustand/shallow';

import { UserDTO } from '@/api/auth/types';
import { useStore } from '@/store';

type UserDTOKey = keyof UserDTO;
type UserSelector = UserDTOKey[];

type OneUserValue<K extends UserDTOKey> = UserDTO[K] | undefined;
type ManyUserValues<K extends UserDTOKey> = { [Key in K]: UserDTO[Key] | undefined };

function useUserInfo<K extends UserDTOKey>(selector: K): OneUserValue<K>;
function useUserInfo<T extends UserSelector>(selectors: T & UserSelector): ManyUserValues<T[number]>;
function useUserInfo<K extends UserDTOKey>(selectors: K | K[]) {
  const createSelector = (user: UserDTO | null) => {
    if (!user) return undefined;

    if (Array.isArray(selectors)) {
      const fieldValuePairs = selectors.map((selector) => [selector, user[selector]]);
      return Object.fromEntries(fieldValuePairs) as ManyUserValues<K>;
    }

    return user[selectors] as OneUserValue<K>;
  };

  const selectedUser = useStore(useShallow((state) => createSelector(state.user)));

  return selectedUser;
}

export default useUserInfo;
