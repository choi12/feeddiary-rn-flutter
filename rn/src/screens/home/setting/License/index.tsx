import React from 'react';

import CustomHeader from '@/components/common/CustomHeader';
import SafeAreaContainer from '@/components/common/SafeAreaContainer';
import ScrollContainer from '@/components/common/ScrollContainer';

import LicenseBox from './components/LicenseItem';
import { OPEN_SOURCE_LICENSE } from './data';

function License() {
  return (
    <SafeAreaContainer edges={['top']}>
      <CustomHeader title="오픈소스 라이선스" hasBackButton />
      <ScrollContainer hasPadding>
        {OPEN_SOURCE_LICENSE.map((licenseInfo) => (
          <LicenseBox key={licenseInfo.libraryName} licenseInfo={licenseInfo} />
        ))}
      </ScrollContainer>
    </SafeAreaContainer>
  );
}

export default License;
