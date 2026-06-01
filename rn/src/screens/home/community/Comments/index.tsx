import React from 'react';
import { StyleSheet } from 'react-native';

import Container from '@/components/common/Container';
import SafeAreaContainer from '@/components/common/SafeAreaContainer';
import StatusBarBox from '@/components/common/StatusBarBox';
import { COLORS } from '@/constants';
import useTypedRoute from '@/hooks/core/navigation/useTypedRoute';

import CommentHeader from './components/CommentHeader';
import CommentInputBox from './components/CommentInputBox';
import CommentList from './components/CommentList';
import CommentProvider from './context/CommentProvider';

function Comments() {
  const {
    params: { diaryIdx, author },
  } = useTypedRoute<'Comments'>();

  return (
    <CommentProvider diaryIdx={diaryIdx} author={author}>
      <SafeAreaContainer edges={['bottom']}>
        <StatusBarBox backgroundColor={COLORS.CORE.BACKGROUND} />
        <CommentHeader />
        <Container backgroundColor={COLORS.CORE.BACKGROUND} style={styles.container}>
          <CommentList />
          <CommentInputBox />
        </Container>
      </SafeAreaContainer>
    </CommentProvider>
  );
}

const styles = StyleSheet.create({
  container: {
    justifyContent: 'space-between',
  },
});

export default Comments;
