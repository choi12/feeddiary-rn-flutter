import { InfiniteData, QueryObserverResult } from '@tanstack/react-query';
import React, { useRef } from 'react';
import { FlatList, ListRenderItem, StyleSheet } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import { MyDiaryDTO } from '@/api/diary/types';
import EmptyStateView from '@/components/common/EmptyStateView';
import ScrollTopButton from '@/components/common/ScrollTopButton';
import ErrorView from '@/components/common/stateView/ErrorView';
import LoadingView from '@/components/common/stateView/LoadingView';
import { LAYOUT, TEXT } from '@/constants';
import useListInteraction from '@/hooks/ui/interaction/useListInteraction';

import MyDiaryCard from './components/MyDiaryCard';

export interface CardListProps {
  diaries: MyDiaryDTO[];
  refetch: () => Promise<QueryObserverResult<InfiniteData<MyDiaryDTO[], unknown>, Error>>;
  onFetchNextPage: () => void;
  isLoading: boolean;
  isError: boolean;
  isScrolled: boolean;
  startScroll: () => void;
  endScroll: () => void;
}

function CardList({
  diaries,
  refetch,
  onFetchNextPage,
  isLoading,
  isError,
  isScrolled,
  startScroll,
  endScroll,
}: CardListProps) {
  const { bottom: safeAreaBottomInset } = useSafeAreaInsets();
  const flatListRef = useRef<FlatList<MyDiaryDTO>>(null);

  const { isRefreshing, handleScroll, handleRefresh, scrollToTop } = useListInteraction({
    flatListRef,
    refetch,
    startScroll,
    endScroll,
  });

  const renderDiaryCard: ListRenderItem<MyDiaryDTO> = ({ item }) => <MyDiaryCard diary={item} />;

  if (isLoading) return <LoadingView />;
  if (isError) return <ErrorView reload={refetch} />;

  return (
    <>
      <FlatList
        ref={flatListRef}
        data={diaries}
        keyExtractor={(diary) => String(diary.idx)}
        renderItem={renderDiaryCard}
        contentContainerStyle={[
          styles.listContainer,
          { paddingBottom: LAYOUT.BOTTOM_TAB_HEIGHT + safeAreaBottomInset },
        ]}
        showsVerticalScrollIndicator={false}
        onEndReached={({ distanceFromEnd }) => {
          if (distanceFromEnd < 0) return;
          onFetchNextPage();
        }}
        onEndReachedThreshold={0.8}
        initialNumToRender={10}
        windowSize={10}
        onScroll={handleScroll}
        ListEmptyComponent={<EmptyStateView message={TEXT.DIARY.MY_DIARY_EMPTY} />}
        onRefresh={handleRefresh}
        refreshing={isRefreshing}
      />
      {isScrolled && <ScrollTopButton onPress={scrollToTop} />}
    </>
  );
}

const styles = StyleSheet.create({
  listContainer: {
    gap: 40,
    padding: 12,
    paddingTop: 40,
  },
});

export default CardList;
