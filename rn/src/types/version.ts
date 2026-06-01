export enum VersionStatus {
  REQUIRED,
  OPTIONAL,
  UP_TO_DATE,
}

export type VersionCheckReturn = {
  status: VersionStatus;
  latestVersion: string;
  currentVersion: string;
};
