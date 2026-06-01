import { navigate } from '../navigation/navigate';

export const moveToComments = (userNickname: string, diaryIdx: number) => {
  navigate('Comments', { diaryIdx, author: userNickname });
};
