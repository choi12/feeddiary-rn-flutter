import React from 'react';
import { StyleSheet, TouchableOpacity } from 'react-native';

import VectorIcon from '@/components/common/VectorIcon';
import { COLORS } from '@/constants';

import useDeleteComment from '../../../hooks/useDeleteComment';

interface CommentDeleteButtonProps {
  commentIdx: number;
}

function CommentDeleteButton({ commentIdx }: CommentDeleteButtonProps) {
  const { handleOpenDeleteModal } = useDeleteComment({ commentIdx });

  return (
    <TouchableOpacity
      onPress={handleOpenDeleteModal}
      style={styles.deleteButton}
      accessibilityRole="button"
      accessibilityLabel="댓글 삭제"
    >
      <VectorIcon type="Ionicons" name="close" size={16} color={COLORS.GRAYSCALE.GRAY} />
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  deleteButton: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 5,
    position: 'absolute',
    right: 5,
    top: 5,
  },
});

export default React.memo(CommentDeleteButton);
