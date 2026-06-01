import { CommentResponseSchema } from './response';

export type CommentDTO = {
  idx: number;
  nickname: string;
  background: string;
  character: string;
  text: string;
  createdAt: string;
  userImage: string;
};

export const CommentDTOSchema = CommentResponseSchema.transform(
  (c): CommentDTO => ({
    idx: c.idx,
    nickname: c.nickname,
    background: c.background,
    character: c.character,
    text: c.text,
    createdAt: c.created_time,
    userImage: c.user_image,
  }),
);

export const CommentsDTOSchema = CommentDTOSchema.array();
