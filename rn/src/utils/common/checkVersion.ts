import { version as appVersion } from '../../../package.json';
import { APIGetAppVersion } from '@/api/etc/APIGetAppVersion';
import { VERSION_REGEX } from '@/constants';
import { VersionCheckReturn, VersionStatus } from '@/types/version';

import { reportError } from '../error/reportError';

const getUpdateStatus = (latestVersion: string, currentVersion: string): VersionStatus => {
  const isValidVersion = (version: string) => VERSION_REGEX.test(version);

  if (!isValidVersion(latestVersion) || !isValidVersion(currentVersion)) {
    const error = new Error(`invalid version format - latest: ${latestVersion}, current: ${currentVersion}`);
    reportError(error);
    // 실패 시 안전하게 업데이트 필요로 처리
    return VersionStatus.REQUIRED;
  }

  const [majorLatest, minorLatest, patchLatest] = latestVersion
    .split('.')
    .map((versionSegment) => Number(versionSegment));
  const [major, minor, patch] = currentVersion.split('.').map((versionSegment) => Number(versionSegment));

  if (major < majorLatest || (major === majorLatest && minor < minorLatest)) {
    return VersionStatus.REQUIRED;
  }
  if (major === majorLatest && minor === minorLatest && patch < patchLatest) {
    return VersionStatus.OPTIONAL;
  }

  return VersionStatus.UP_TO_DATE;
};

export const checkVersion = async (): Promise<VersionCheckReturn> => {
  const currentVersion = appVersion;
  const latestVersion = await APIGetAppVersion();

  return { status: getUpdateStatus(latestVersion, currentVersion), latestVersion, currentVersion };
};
