// checkVersion 유틸 테스트 — major/minor/patch 비교 및 잘못된 포맷 처리 분기 전수
import { APIGetAppVersion } from '@/api/etc/APIGetAppVersion';
import { VersionStatus } from '@/types/version';
import { checkVersion } from '@/utils/common/checkVersion';
import { reportError } from '@/utils/error/reportError';

// 현재 앱 버전을 1.2.3으로 고정해 latest와의 비교 분기를 검증
jest.mock('../../../../package.json', () => ({ version: '1.2.3' }));
jest.mock('@/api/etc/APIGetAppVersion', () => ({ APIGetAppVersion: jest.fn() }));
jest.mock('@/utils/error/reportError', () => ({ reportError: jest.fn() }));

const mockGetAppVersion = APIGetAppVersion as jest.MockedFunction<typeof APIGetAppVersion>;

const withLatest = (latest: string) => {
  mockGetAppVersion.mockResolvedValueOnce(latest);
  return checkVersion();
};

describe('checkVersion', () => {
  beforeEach(() => jest.clearAllMocks());

  it('returns UP_TO_DATE when versions match', async () => {
    expect((await withLatest('1.2.3')).status).toBe(VersionStatus.UP_TO_DATE);
  });

  it('returns REQUIRED when the latest major is higher', async () => {
    expect((await withLatest('2.0.0')).status).toBe(VersionStatus.REQUIRED);
  });

  it('returns REQUIRED when the latest minor is higher', async () => {
    expect((await withLatest('1.3.0')).status).toBe(VersionStatus.REQUIRED);
  });

  it('returns OPTIONAL when only the latest patch is higher', async () => {
    expect((await withLatest('1.2.4')).status).toBe(VersionStatus.OPTIONAL);
  });

  it('returns UP_TO_DATE when the current version is ahead', async () => {
    expect((await withLatest('1.1.9')).status).toBe(VersionStatus.UP_TO_DATE);
    expect((await withLatest('1.2.2')).status).toBe(VersionStatus.UP_TO_DATE);
  });

  it('falls back to REQUIRED and reports on an invalid version format', async () => {
    expect((await withLatest('abc')).status).toBe(VersionStatus.REQUIRED);
    expect(reportError).toHaveBeenCalledTimes(1);
  });

  it('echoes the latest and current versions in the result', async () => {
    const result = await withLatest('1.2.4');
    expect(result.latestVersion).toBe('1.2.4');
    expect(result.currentVersion).toBe('1.2.3');
  });
});
