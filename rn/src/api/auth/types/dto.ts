import { SignInType } from '@/types/auth';

import { UserResponseSchema } from './response';

export type UserDTO = {
  idx: number;
  account: string;
  userId: string;
  nickname: string;
  image: string;
  background: string;
  character: string;
  type: SignInType;
  createdAt: Date;
  token: string;
  fcmToken?: string;
};

export const UserDTOSchema = UserResponseSchema.transform(
  (u): UserDTO => ({
    idx: u.idx,
    account: u.account,
    userId: u.user_id,
    nickname: u.nickname,
    image: u.image,
    background: u.background,
    character: u.character,
    type: u.type,
    createdAt: u.created_time,
    token: u.token,
    fcmToken: u.fcm_token,
  }),
);
