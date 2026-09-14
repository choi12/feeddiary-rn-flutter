// 라이선스 화면 — 사용 라이브러리와 번들 에셋의 라이선스 목록을 나열
import React from 'react';

import CustomHeader from '@/components/common/CustomHeader';
import SafeAreaContainer from '@/components/common/SafeAreaContainer';
import ScrollContainer from '@/components/common/ScrollContainer';

import LicenseBox from './components/LicenseItem';
import { OPEN_SOURCE_LICENSE } from './data';

function License() {
  return (
    <SafeAreaContainer edges={['top']}>
      <CustomHeader title="라이선스" hasBackButton />
      <ScrollContainer hasPadding>
        {OPEN_SOURCE_LICENSE.map((licenseInfo) => (
          <LicenseBox key={licenseInfo.libraryName} licenseInfo={licenseInfo} />
        ))}
      </ScrollContainer>
    </SafeAreaContainer>
  );
}

export default License;
