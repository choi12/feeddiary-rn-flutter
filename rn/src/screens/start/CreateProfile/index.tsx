import React, { useRef } from 'react';
import { ScrollView } from 'react-native';

import SafeAreaContainer from '@/components/common/SafeAreaContainer';
import ScrollContainer from '@/components/common/ScrollContainer';
import Line from '@/components/profile/Line';
import NicknameSection from '@/components/profile/NicknameSection';
import ProfileImageSection from '@/components/profile/ProfileImageSection';
import ProfileProvider from '@/context/profile/ProfileProvider';
import useTypedRoute from '@/hooks/core/navigation/useTypedRoute';

import SignUpButton from './components/SignUpButton';
import TitleBox from './components/TitleBox';

function CreateProfile() {
  const {
    params: { uid, email, type },
  } = useTypedRoute<'CreateProfile'>();

  const scrollviewRef = useRef<ScrollView>(null);
  const scrollToEnd = () => scrollviewRef.current?.scrollToEnd({ animated: true });

  return (
    <ProfileProvider>
      <SafeAreaContainer>
        <ScrollContainer ref={scrollviewRef} hasPadding>
          <TitleBox />
          <NicknameSection />
          <Line margin={40} />
          <ProfileImageSection scrollToEnd={scrollToEnd} />
        </ScrollContainer>
        <SignUpButton type={type} email={email} uid={uid} />
      </SafeAreaContainer>
    </ProfileProvider>
  );
}

export default CreateProfile;
