import React, { useRef } from 'react';
import { ScrollView } from 'react-native';

import CustomHeader from '@/components/common/CustomHeader';
import SafeAreaContainer from '@/components/common/SafeAreaContainer';
import ScrollContainer from '@/components/common/ScrollContainer';
import Line from '@/components/profile/Line';
import NicknameSection from '@/components/profile/NicknameSection';
import ProfileImageSection from '@/components/profile/ProfileImageSection';
import ProfileProvider from '@/context/profile/ProfileProvider';

import DeleteAccountButton from './components/DeleteAccountButton';
import UpdateProfileButton from './components/UpdateProfileButton';

function UpdateProfile() {
  const scrollviewRef = useRef<ScrollView>(null);
  const scrollToEnd = () => scrollviewRef.current?.scrollToEnd({ animated: true });

  return (
    <ProfileProvider>
      <SafeAreaContainer>
        <CustomHeader title="프로필 수정" rightItem={<DeleteAccountButton />} hasBackButton />
        <ScrollContainer ref={scrollviewRef} hasPadding>
          <NicknameSection />
          <Line margin={30} />
          <ProfileImageSection scrollToEnd={scrollToEnd} />
        </ScrollContainer>
        <UpdateProfileButton />
      </SafeAreaContainer>
    </ProfileProvider>
  );
}

export default UpdateProfile;
