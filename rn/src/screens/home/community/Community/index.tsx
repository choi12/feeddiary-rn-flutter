// 커뮤니티 화면 — 공개된 일기 목록을 스크롤 헤더와 함께 보여주는 메인 탭 화면
import React from 'react';

import Container from '@/components/common/Container';
import { COLORS } from '@/constants';

import AnimatedHeader from './components/AnimatedHeader';
import CommunityList from './components/CommunityList';
import CommunityHeaderProvider from './context/CommunityHeaderProvider';

function Community() {
  return (
    <CommunityHeaderProvider>
      <Container isMain backgroundColor={COLORS.CORE.BACKGROUND}>
        <AnimatedHeader />
        <CommunityList />
      </Container>
    </CommunityHeaderProvider>
  );
}

export default Community;
