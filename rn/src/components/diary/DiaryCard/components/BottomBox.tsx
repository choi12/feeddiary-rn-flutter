import React from 'react';
import { StyleSheet, View } from 'react-native';

import { CommunityDiaryDTO } from '@/api/community/types';
import { MyDiaryDTO } from '@/api/diary/types';
import { MAX_DISPLAY_COUNT, OVERFLOW_COUNT_TEXT } from '@/constants';

import { useDiaryCardContext } from '../context/DiaryCardContext';

import CountBox from './CountBox';

type BottomBoxDiary = MyDiaryDTO | CommunityDiaryDTO;

function BottomBox() {
  const { diary } = useDiaryCardContext();
  const { likeCount, commentCount } = diary as BottomBoxDiary;

  return (
    <View style={styles.bottomBox}>
      <CountBox type="like" count={likeCount > MAX_DISPLAY_COUNT ? OVERFLOW_COUNT_TEXT : likeCount} />
      <CountBox type="comment" count={commentCount} />
    </View>
  );
}

const styles = StyleSheet.create({
  bottomBox: {
    flexDirection: 'row',
    marginTop: 20,
    justifyContent: 'flex-end',
  },
});

export default BottomBox;
