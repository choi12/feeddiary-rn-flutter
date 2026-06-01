import React from 'react';
import { StyleSheet, View } from 'react-native';

import { MAX_DISPLAY_COUNT, OVERFLOW_COUNT_TEXT } from '@/constants';

import { useDiaryCardContext } from '../context/DiaryCardContext';

import CountBox from './CountBox';

function BottomBox() {
  const { diary } = useDiaryCardContext();

  // 좋아요·댓글 카운트는 MyDiary·Community 일기에만 존재(DailyDiary 제외)
  if (!('likeCount' in diary)) return null;

  const { likeCount, commentCount } = diary;

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
