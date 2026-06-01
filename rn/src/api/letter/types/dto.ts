import { LetterResponseSchema } from './response';

export interface LetterDTO {
  idx: number;
  text: string;
  createdAt: string;
}

export const LetterDTOSchema = LetterResponseSchema.transform(
  (l): LetterDTO => ({
    idx: l.idx,
    text: l.text,
    createdAt: l.created_time,
  }),
);

export const LettersDTOSchema = LetterDTOSchema.array();
