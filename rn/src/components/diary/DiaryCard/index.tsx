import React, { PropsWithChildren, useMemo } from 'react';
import { Pressable, StyleSheet } from 'react-native';

import { COLORS } from '@/constants';

import BottomBox from './components/BottomBox';
import Content from './components/Content';
import ContentBox from './components/ContentBox';
import DayBox from './components/DayBox';
import PointImage from './components/PointImage';
import TopBox from './components/TopBox';
import TopBoxHeaderContainer from './components/TopBoxHeaderContainer';
import { DiaryCardContext } from './context/DiaryCardContext';
import useDiaryCardNavigation from './hooks/useDiaryCardNavigation';
import { Diary, DiaryCardSize } from './types';

interface DiaryCardProps {
  diary: Diary;
  size?: DiaryCardSize;
}

/**
 * @example
 * <DiaryCard diary={diary}>
 *   <DiaryCard.TopBox>
 *     <DiaryCard.Content />
 *   </DiaryCard.TopBox>
 *   <DiaryCard.BottomBox />
 * </DiaryCard>
 */
function DiaryCard({ children, diary, size = 'large' }: PropsWithChildren<DiaryCardProps>) {
  const navigateToDiaryDetails = useDiaryCardNavigation();

  const contextValue = useMemo(() => ({ diary, size }), [diary, size]);

  return (
    <DiaryCardContext.Provider value={contextValue}>
      <Pressable onPress={() => navigateToDiaryDetails(diary.idx)} style={styles.card}>
        {children}
      </Pressable>
    </DiaryCardContext.Provider>
  );
}

DiaryCard.DayBox = DayBox;
DiaryCard.ContentBox = ContentBox;
DiaryCard.TopBox = TopBox;
DiaryCard.TopBoxHeaderContainer = TopBoxHeaderContainer;
DiaryCard.Content = Content;
DiaryCard.BottomBox = BottomBox;
DiaryCard.PointImage = PointImage;

const styles = StyleSheet.create({
  card: {
    backgroundColor: COLORS.GRAYSCALE.WHITE,
    borderRadius: 10,
    padding: 20,
    flexDirection: 'row',
  },
});

export default DiaryCard;
