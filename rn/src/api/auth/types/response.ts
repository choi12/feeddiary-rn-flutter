import { z } from 'zod';

export const SignInTypeSchema = z.enum(['google', 'apple']);

export const UserResponseSchema = z.object({
  idx: z.number(),
  account: z.string(),
  user_id: z.string(),
  nickname: z.string(),
  image: z.string(),
  background: z.string(),
  character: z.string(),
  type: SignInTypeSchema,
  created_time: z.coerce.date(),
  token: z.string(),
  fcm_token: z.string().optional(),
});

export type UserResponse = z.infer<typeof UserResponseSchema>;
