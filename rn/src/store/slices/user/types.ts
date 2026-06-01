import { UserDTO } from '@/api/auth/types';

export interface UserSlice {
  user: UserDTO | null;
  saveUser: (data: UserDTO) => void;
  removeUser: () => void;
}
