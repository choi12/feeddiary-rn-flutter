import React from 'react';
import { StyleSheet, View } from 'react-native';

import { CommentDTO } from '@/api/comment/types';
import ProfileImageBox from '@/components/profile/ProfileImageBox';
import { COLORS } from '@/constants';
import useUserInfo from '@/hooks/store/useUserInfo';
import { Profile } from '@/types/profile';

import CommentContent from './components/CommentContent';
import CommentDeleteButton from './components/CommentDeleteButton';

interface CommentCardProps {
  comment: CommentDTO;
}

function CommentCard({ comment }: CommentCardProps) {
  const userNickname = useUserInfo('nickname');
  const canDelete = comment.nickname === userNickname;

  const profile: Profile = {
    image: comment.userImage ?? '',
    background: comment.background,
    character: comment.character,
  };

  return (
    <View style={styles.container}>
      <ProfileImageBox size={46} profile={profile} />
      <CommentContent comment={comment} />
      {canDelete && <CommentDeleteButton commentIdx={comment.idx} />}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    backgroundColor: COLORS.GRAYSCALE.WHITE,
    borderRadius: 10,
    padding: 15,
    flexDirection: 'row',
    gap: 10,
  },
});

export default React.memo(CommentCard);
