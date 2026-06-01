import React from 'react';
import { StyleSheet } from 'react-native';
import { Image as FastImage } from 'expo-image';

import { Logo } from '@/assets/images';
import Container from '@/components/common/Container';
import CustomHeader from '@/components/common/CustomHeader';
import SafeAreaContainer from '@/components/common/SafeAreaContainer';
import ErrorView from '@/components/common/stateView/ErrorView';
import LoadingView from '@/components/common/stateView/LoadingView';
import Text from '@/components/common/Text';
import { COLORS } from '@/constants';

import AppVersionNotiBox from './components/AppVersionNotiBox';
import useAppVersion from './hooks/useAppVersion';

function AppVersion() {
  const { versionInfo, refetch, isLoading, isError } = useAppVersion();
  const { latestVersion, currentVersion, isLatest } = versionInfo;

  return (
    <SafeAreaContainer>
      <CustomHeader title="앱 버전 정보" hasBackButton />
      <Container hasPadding>
        {isLoading ? (
          <LoadingView />
        ) : isError ? (
          <ErrorView reload={refetch} />
        ) : (
          <Container style={styles.container}>
            <FastImage source={Logo} style={styles.logoImage} contentFit="contain" />
            <AppVersionNotiBox latestVersion={latestVersion} isLatest={isLatest} />
            <Text style={styles.versionText}>version: {currentVersion}</Text>
          </Container>
        )}
      </Container>
    </SafeAreaContainer>
  );
}

const styles = StyleSheet.create({
  container: {
    alignItems: 'center',
    justifyContent: 'center',
  },
  logoImage: {
    aspectRatio: 3.35 / 1,
    height: 25,
    marginBottom: 25,
  },
  versionText: {
    fontSize: 13,
    color: COLORS.GRAYSCALE.LIGHT_BLACK,
    marginBottom: 30,
  },
});

export default AppVersion;
