import React from 'react';
import { ActivityIndicator, StyleSheet } from 'react-native';

import AnimatedPressable from '@/components/common/AnimatedPressable';
import VectorIcon from '@/components/common/VectorIcon';
import { COLORS, LAYOUT } from '@/constants';

import useCreateComment from '../../../hooks/useCreateComment';

interface CreateCommentButtonProps {
  text: string;
  setText: (text: string) => void;
}

function CreateCommentButton({ text, setText }: CreateCommentButtonProps) {
  const { handleSubmitComment, isPending } = useCreateComment({ text, setText });
  const hasText = !!text.trim();

  return (
    <AnimatedPressable
      onPress={handleSubmitComment}
      disabled={!hasText || isPending}
      style={[styles.sendButton, !hasText && styles.disabled]}
      accessibilityRole="button"
      accessibilityLabel="댓글 등록"
      accessibilityState={{ disabled: !hasText || isPending, busy: isPending }}
    >
      {!isPending ? (
        <VectorIcon type="Octicons" name="paper-airplane" size={20} color={COLORS.GRAYSCALE.WHITE} />
      ) : (
        <ActivityIndicator size="small" color={COLORS.GRAYSCALE.WHITE} />
      )}
    </AnimatedPressable>
  );
}
const styles = StyleSheet.create({
  sendButton: {
    backgroundColor: COLORS.CORE.MAIN,
    height: '100%',
    aspectRatio: 1,
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: LAYOUT.BORDER_RADIUS,
  },
  disabled: { backgroundColor: COLORS.CORE.INPUT },
});

export default CreateCommentButton;
