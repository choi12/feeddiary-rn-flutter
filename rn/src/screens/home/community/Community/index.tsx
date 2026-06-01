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
