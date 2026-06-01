import { useQuery } from '@tanstack/react-query';

import { QUERY_KEYS } from '@/constants';
import { VersionCheckReturn, VersionStatus } from '@/types/version';
import { checkVersion } from '@/utils/common/checkVersion';
import { INDEPENDENT_QUERY_CONFIG } from '@/utils/config/query';

const initialVersionData: VersionCheckReturn = {
  status: VersionStatus.UP_TO_DATE,
  latestVersion: '',
  currentVersion: '',
};

function useAppVersion() {
  const { data, refetch, isLoading, isError } = useQuery({
    ...INDEPENDENT_QUERY_CONFIG,
    queryKey: [QUERY_KEYS.APP_VERSION],
    queryFn: checkVersion,
  });

  const versionData = data ?? initialVersionData;
  const versionInfo = {
    ...versionData,
    isLatest: versionData.status === VersionStatus.UP_TO_DATE,
  };

  return { versionInfo, refetch, isLoading, isError };
}

export default useAppVersion;
