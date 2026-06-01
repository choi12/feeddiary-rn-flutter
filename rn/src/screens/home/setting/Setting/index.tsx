// 설정 화면 — 사용자 프로필 요약과 설정 메뉴 목록을 보여주는 메인 탭 화면
import React from 'react';

import Container from '@/components/common/Container';
import CustomHeader from '@/components/common/CustomHeader';
import SafeAreaContainer from '@/components/common/SafeAreaContainer';

import MenuButtonBox from './components/MenuButtonBox';
import UserProfileBox from './components/UserProfileBox';

function Setting() {
  return (
    <SafeAreaContainer>
      <CustomHeader title="설정" />
      <Container>
        <UserProfileBox />
        <MenuButtonBox />
      </Container>
    </SafeAreaContainer>
  );
}

export default Setting;
