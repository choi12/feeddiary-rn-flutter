import React, { useState } from 'react';

import Container from '@/components/common/Container';
import { COLORS } from '@/constants';

import CalendarList from './components/CalendarList';
import CardList from './components/CardList';
import MyDiaryHeader from './components/MyDiaryHeader';
import useDiaryCalendarView from './hooks/useDiaryCalendarView';
import useDiaryCardView from './hooks/useDiaryCardView';
import { MyDiaryTab } from './types';

function MyDiary() {
  const [tab, setTab] = useState<MyDiaryTab>('calendar');

  const calendarDiaries = useDiaryCalendarView();
  const cardDiaries = useDiaryCardView();

  return (
    <Container isMain backgroundColor={COLORS.CORE.BACKGROUND}>
      <MyDiaryHeader selectedTab={tab} onSetTab={setTab} isScrolled={cardDiaries.isScrolled} />
      {tab === 'calendar' ? <CalendarList {...calendarDiaries} /> : <CardList {...cardDiaries} />}
    </Container>
  );
}

export default MyDiary;
