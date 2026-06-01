import React from 'react';

import { MyDiaryDTO } from '@/api/diary/types';
import DiaryCard from '@/components/diary/DiaryCard';
import VisibilityBox from '@/components/diary/VisibilityBox';
import StickerImage from '@/screens/home/myDiary/CreateDiary/components/StickerImage';

interface MyDiaryCardProps {
  diary: MyDiaryDTO;
}

function MyDiaryCard({ diary }: MyDiaryCardProps) {
  return (
    <DiaryCard diary={diary}>
      <DiaryCard.DayBox />
      <DiaryCard.ContentBox>
        <DiaryCard.TopBox>
          <DiaryCard.TopBoxHeaderContainer>
            <StickerImage name={diary.sticker} size={38} />
            <VisibilityBox isVisible={!!diary.isVisible} size="small" />
          </DiaryCard.TopBoxHeaderContainer>
          <DiaryCard.Content />
        </DiaryCard.TopBox>
        <DiaryCard.BottomBox />
      </DiaryCard.ContentBox>
      <DiaryCard.PointImage />
    </DiaryCard>
  );
}

export default MyDiaryCard;
