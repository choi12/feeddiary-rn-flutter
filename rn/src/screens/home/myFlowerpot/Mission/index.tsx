import { useQueryClient } from '@tanstack/react-query';
import React, { useEffect } from 'react';
import { StyleSheet } from 'react-native';

import Container from '@/components/common/Container';
import CustomHeader from '@/components/common/CustomHeader';
import SafeAreaContainer from '@/components/common/SafeAreaContainer';
import { COLORS, LAYOUT, QUERY_KEYS } from '@/constants';

import MissionList from './components/MissionList';
import TabButtonBox from './components/TabButtonBox';
import MissionProvider from './context/MissionProvider';

function Mission() {
  const queryClient = useQueryClient();

  useEffect(() => {
    return () => {
      queryClient.invalidateQueries({ queryKey: [QUERY_KEYS.FLOWERPOT] });
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  return (
    <MissionProvider>
      <SafeAreaContainer backgroundColor={COLORS.CORE.BACKGROUND}>
        <CustomHeader title="오늘의 미션" hasCloseButton />
        <Container backgroundColor={COLORS.CORE.BACKGROUND} style={styles.container}>
          <TabButtonBox />
          <MissionList />
        </Container>
      </SafeAreaContainer>
    </MissionProvider>
  );
}

const styles = StyleSheet.create({
  container: {
    paddingHorizontal: LAYOUT.PADDING,
    paddingTop: 10,
  },
});

export default Mission;
