import React from 'react';
import { StyleSheet, FlatList, ListRenderItem, GestureResponderEvent } from 'react-native';

import { LetterDTO } from '@/api/letter/types';
import EmptyStateView from '@/components/common/EmptyStateView';
import { LAYOUT, TEXT } from '@/constants';

import useLetters from '../../hooks/useLetters';

import LetterCard from './components/LetterCard';

export const LETTER_NUM_COLUMNS = 2;

interface LetterListProps {
  editMode: boolean;
  onOpenLetterModal: (event: GestureResponderEvent, letter: LetterDTO) => void;
}

function LetterList({ editMode, onOpenLetterModal }: LetterListProps) {
  const { letters, handleFetchNextPage } = useLetters();

  const renderLetterCard: ListRenderItem<LetterDTO> = ({ item, index }) => {
    return <LetterCard letter={item} letterIndex={index} editMode={editMode} onOpenLetterModal={onOpenLetterModal} />;
  };

  return (
    <FlatList
      data={letters}
      keyExtractor={(letter) => String(letter.idx)}
      renderItem={renderLetterCard}
      contentContainerStyle={[styles.listContainer, letters.length === 0 && styles.emptyListContainer]}
      numColumns={LETTER_NUM_COLUMNS}
      showsVerticalScrollIndicator={false}
      onEndReached={({ distanceFromEnd }) => {
        if (distanceFromEnd < 0) return;
        handleFetchNextPage();
      }}
      onEndReachedThreshold={0.8}
      initialNumToRender={10}
      windowSize={10}
      ListEmptyComponent={<EmptyStateView message={TEXT.LETTER.LETTER_EMPTY} />}
      bounces={false}
      overScrollMode="never"
    />
  );
}

const styles = StyleSheet.create({
  listContainer: {
    paddingTop: 30,
    paddingBottom: 35 + LAYOUT.BOTTOM_TAB_HEIGHT,
  },
  emptyListContainer: {
    paddingTop: 0,
    paddingBottom: 0,
  },
});

export default LetterList;
