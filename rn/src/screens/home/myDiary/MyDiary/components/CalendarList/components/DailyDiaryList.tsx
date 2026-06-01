import React from 'react';
import { FlatList, ListRenderItem, StyleSheet } from 'react-native';
import Animated, { FadeIn, FadeOut } from 'react-native-reanimated';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import { DailyDiaryDTO } from '@/api/diary/types';
import { LAYOUT } from '@/constants';

import DailyDiaryCard from './DailyDiaryCard';

interface DailyDiaryListProps {
  dailyDiaries: DailyDiaryDTO[];
}

function DailyDiaryList({ dailyDiaries }: DailyDiaryListProps) {
  const { bottom: safeAreaBottomInset } = useSafeAreaInsets();

  const renderDailyDiaryCard: ListRenderItem<DailyDiaryDTO> = ({ item }) => (
    <Animated.View entering={FadeIn} exiting={FadeOut.duration(100)}>
      <DailyDiaryCard diary={item} />
    </Animated.View>
  );

  return (
    <FlatList
      data={dailyDiaries}
      keyExtractor={(dailyDiary) => String(dailyDiary.idx)}
      renderItem={renderDailyDiaryCard}
      contentContainerStyle={[styles.listContainer, { paddingBottom: LAYOUT.BOTTOM_TAB_HEIGHT + safeAreaBottomInset }]}
      showsVerticalScrollIndicator={false}
      windowSize={3}
      bounces={false}
      overScrollMode="never"
    />
  );
}

const styles = StyleSheet.create({
  listContainer: {
    paddingTop: 25,
    gap: 25,
  },
});

export default DailyDiaryList;
