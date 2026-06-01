export type APIStatus = 'success' | 'failed';

export interface APIResponse<T> {
  status: APIStatus;
  message?: string;
  resData?: T;
}
