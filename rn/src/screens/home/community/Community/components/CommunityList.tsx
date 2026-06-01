import React, { useEffect, useRef } from 'react';
import { FlatList, ListRenderItem, StyleSheet } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import { CommunityDiaryDTO } from '@/api/community/types';
import EmptyStateView from '@/components/common/EmptyStateView';
import ScrollTopButton from '@/components/common/ScrollTopButton';
import ErrorView from '@/components/common/stateView/ErrorView';
import LoadingView from '@/components/common/stateView/LoadingView';
import { COLORS, LAYOUT, TEXT } from '@/constants';
import useListInteraction from '@/hooks/ui/interaction/useListInteraction';

import { useCommunityHeaderContext } from '../context/CommunityHeaderContext';
import useCommunityDiaries from '../hooks/useCommunityDiaries';

import CommunityDiaryCard from './CommunityDiaryCard';

function CommunityList() {
  const { bottom: safeAreaBottomInset } = useSafeAreaInsets();
  const { isScrolled, startScroll, endScroll, sort } = useCommunityHeaderContext();

  const flatListRef = useRef<FlatList<CommunityDiaryDTO>>(null);

  const { communityDiaries, refetch, handleFetchNextPage, isLoading, isError } = useCommunityDiaries();
  const { isRefreshing, handleScroll, handleRefresh, scrollToTop } = useListInteraction({
    flatListRef,
    refetch,
    startScroll,
    endScroll,
  });

  const renderCommunityDiaryCard: ListRenderItem<CommunityDiaryDTO> = ({ item }) => <CommunityDiaryCard diary={item} />;

  useEffect(() => {
    scrollToTop();
  }, [sort, scrollToTop]);

  if (isLoading) return <LoadingView />;
  if (isError) return <ErrorView reload={refetch} />;

  return (
    <>
      <FlatList
        ref={flatListRef}
        data={communityDiaries}
        keyExtractor={(communityDiary) => String(communityDiary.idx)}
        renderItem={renderCommunityDiaryCard}
        contentContainerStyle={[
          styles.listContainer,
          { paddingBottom: LAYOUT.BOTTOM_TAB_HEIGHT + safeAreaBottomInset },
        ]}
        showsVerticalScrollIndicator={false}
        onEndReached={({ distanceFromEnd }) => {
          if (distanceFromEnd < 0) return;
          handleFetchNextPage();
        }}
        onEndReachedThreshold={0.8}
        initialNumToRender={10}
        windowSize={10}
        onScroll={handleScroll}
        ListEmptyComponent={<EmptyStateView message={TEXT.DIARY.COMMUNITY_EMPTY} />}
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
    backgroundColor: COLORS.CORE.BACKGROUND,
    paddingTop: 20,
  },
});

export default CommunityList;
