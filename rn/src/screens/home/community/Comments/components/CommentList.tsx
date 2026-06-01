import React, { useCallback, useState } from 'react';
import { FlatList, ListRenderItem, StyleSheet } from 'react-native';

import { CommentDTO } from '@/api/comment/types';
import EmptyStateView from '@/components/common/EmptyStateView';
import ErrorView from '@/components/common/stateView/ErrorView';
import LoadingView from '@/components/common/stateView/LoadingView';
import { LAYOUT, TEXT } from '@/constants';

import { useCommentContext } from '../context/CommentContext';

import CommentCard from './CommentCard';

function CommentList() {
  const { comments, refetch, isLoading, isError } = useCommentContext();
  const [isRefreshing, setIsRefreshing] = useState(false);

  const renderCommentCard: ListRenderItem<CommentDTO> = ({ item: comment }) => <CommentCard comment={comment} />;

  const onRefresh = useCallback(() => {
    setIsRefreshing(true);
    refetch().finally(() => setIsRefreshing(false));
  }, [refetch]);

  if (isLoading) return <LoadingView />;
  if (isError) return <ErrorView reload={refetch} />;

  return (
    <FlatList
      data={comments}
      keyExtractor={(comment) => String(comment.idx)}
      renderItem={renderCommentCard}
      contentContainerStyle={styles.listContainer}
      showsVerticalScrollIndicator={false}
      ListEmptyComponent={<EmptyStateView message={TEXT.COMMENT.EMPTY} />}
      onRefresh={onRefresh}
      refreshing={isRefreshing}
    />
  );
}

const styles = StyleSheet.create({
  listContainer: {
    paddingHorizontal: LAYOUT.PADDING,
    paddingBottom: LAYOUT.PADDING,
    gap: 10,
  },
});

export default CommentList;
