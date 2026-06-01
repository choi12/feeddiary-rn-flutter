import React from 'react';

import { CommunityDiaryDTO } from '@/api/community/types';
import CustomHeader from '@/components/common/CustomHeader';
import NicknameBox from '@/components/diary/NicknameBox';
import { NicknameBoxProfile } from '@/types/profile';

import DotsButton from './components/DotsButton';

interface DiaryDetailsHeaderProps {
  diary: CommunityDiaryDTO | undefined;
  isMyDiary: boolean;
  onOpenDiaryActionModal: () => void;
}

function DiaryDetailsHeader({ diary, isMyDiary, onOpenDiaryActionModal }: DiaryDetailsHeaderProps) {
  const profile: NicknameBoxProfile = {
    image: diary?.userImage ?? '',
    background: diary?.background,
    character: diary?.character,
    nickname: diary?.nickname ?? '',
  };

  return (
    <CustomHeader
      title={diary ? isMyDiary ? '나의 일기' : <NicknameBox size="large" profile={profile} /> : null}
      hasBackButton
      rightItem={isMyDiary && <DotsButton onPress={onOpenDiaryActionModal} />}
    />
  );
}
export default DiaryDetailsHeader;
