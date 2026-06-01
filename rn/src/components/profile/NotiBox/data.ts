import { ImageRequireSource } from 'react-native';

import { Success, Error } from '@/assets/images';
import { COLORS } from '@/constants';
import { NicknameValidationStatus } from '@/types/profile';

type NotiConfig = {
  color: string;
  icon: ImageRequireSource;
  text: string;
};

export const NICKNAME_NOTI_PRESET: Record<Exclude<NicknameValidationStatus, undefined>, NotiConfig> = {
  success: { color: COLORS.CORE.MAIN, icon: Success, text: '사용 가능한 닉네임이에요.' },
  duplicate: { color: COLORS.ACCENT.ORANGE, icon: Error, text: '이미 사용 중인 닉네임이에요.' },
  regex: { color: COLORS.ACCENT.ORANGE, icon: Error, text: '한글, 영문 또는 숫자 2~8글자로 입력해 주세요.' },
};
