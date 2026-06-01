import React from 'react';
import { StyleSheet, View } from 'react-native';

import { CommunityDiaryDTO } from '@/api/community/types';
import VisibilityBox from '@/components/diary/VisibilityBox';
import { COLORS, LAYOUT } from '@/constants';

import CommentButton from './components/CommentButton';
import LikeButton from './components/LikeButton';
import ReportButton from './components/ReportButton';

interface BottomBoxProps {
  diary: CommunityDiaryDTO;
  isMyDiary: boolean;
  isVisible: boolean;
}

function BottomBox({ diary, isMyDiary, isVisible }: BottomBoxProps) {
  return (
    <View style={styles.bottomBox}>
      <View style={styles.countBox}>
        <LikeButton diary={diary} isMyDiary={isMyDiary} />
        <CommentButton diary={diary} />
      </View>
      {isMyDiary ? <VisibilityBox size="large" isVisible={isVisible} /> : <ReportButton diaryIdx={diary.idx} />}
    </View>
  );
}

const styles = StyleSheet.create({
  bottomBox: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    borderTopWidth: 0.5,
    borderColor: COLORS.GRAYSCALE.WHITE_GRAY,
    paddingVertical: 15,
    paddingHorizontal: LAYOUT.PADDING,
    backgroundColor: COLORS.GRAYSCALE.WHITE,
  },
  countBox: {
    flexDirection: 'row',
    alignItems: 'center',
  },
});

export default BottomBox;
