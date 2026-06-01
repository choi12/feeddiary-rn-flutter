import React from 'react';

import { CommunityDiaryDTO } from '@/api/community/types';
import DiaryCard from '@/components/diary/DiaryCard';
import NicknameBox from '@/components/diary/NicknameBox';
import StickerImage from '@/screens/home/myDiary/CreateDiary/components/StickerImage';
import { NicknameBoxProfile } from '@/types/profile';

interface CommunityDiaryCardProps {
  diary: CommunityDiaryDTO;
}

function CommunityDiaryCard({ diary }: CommunityDiaryCardProps) {
  const profile: NicknameBoxProfile = {
    image: diary.userImage ?? '',
    background: diary.background,
    character: diary.character,
    nickname: diary.nickname ?? '',
  };

  return (
    <DiaryCard diary={diary}>
      <DiaryCard.DayBox />
      <DiaryCard.ContentBox>
        <DiaryCard.TopBox>
          <DiaryCard.TopBoxHeaderContainer>
            <StickerImage name={diary.sticker} size={38} />
            <NicknameBox profile={profile} size="small" />
          </DiaryCard.TopBoxHeaderContainer>
          <DiaryCard.Content />
        </DiaryCard.TopBox>
        <DiaryCard.BottomBox />
      </DiaryCard.ContentBox>
      <DiaryCard.PointImage />
    </DiaryCard>
  );
}

export default CommunityDiaryCard;
