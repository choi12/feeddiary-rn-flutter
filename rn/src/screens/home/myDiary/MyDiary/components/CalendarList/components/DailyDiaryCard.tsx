import React from 'react';

import { DailyDiaryDTO } from '@/api/diary/types';
import DiaryCard from '@/components/diary/DiaryCard';
import VisibilityBox from '@/components/diary/VisibilityBox';
import StickerImage from '@/screens/home/myDiary/CreateDiary/components/StickerImage';

interface DailyDiaryCardProps {
  diary: DailyDiaryDTO;
}

function DailyDiaryCard({ diary }: DailyDiaryCardProps) {
  return (
    <DiaryCard diary={diary} size="small">
      <DiaryCard.DayBox />
      <DiaryCard.ContentBox>
        <DiaryCard.TopBox>
          <DiaryCard.TopBoxHeaderContainer>
            <StickerImage name={diary.sticker} size={32} />
            <VisibilityBox isVisible={!!diary.isVisible} size="small" />
          </DiaryCard.TopBoxHeaderContainer>
          <DiaryCard.Content />
        </DiaryCard.TopBox>
      </DiaryCard.ContentBox>
      <DiaryCard.PointImage />
    </DiaryCard>
  );
}

export default React.memo(DailyDiaryCard);
