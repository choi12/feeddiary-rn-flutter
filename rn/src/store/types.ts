import { ModalSlice } from './slices/modal/types';
import { UISlice } from './slices/ui/types';
import { UserSlice } from './slices/user/types';

export type StoreState = ModalSlice & UISlice & UserSlice;
