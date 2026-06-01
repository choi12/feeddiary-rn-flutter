// 공용 axios 인스턴스 — 토큰 주입 요청 인터셉터 + 상태코드별 커스텀 에러 매핑 응답 인터셉터
import axios, { AxiosError, AxiosInstance, AxiosResponse, InternalAxiosRequestConfig } from 'axios';
import Config from 'react-native-config';

import { API_CONFIG, ERROR_MESSAGES } from '@/constants';
import { APIError, BaseError, ConflictError, NetworkError, TimeoutError, UnauthorizedError } from '@/types/errors';
import { getAccessToken } from '@/utils/storage/auth';

const request: AxiosInstance = axios.create({
  baseURL: Config.API_SERVER,
  timeout: API_CONFIG.TIMEOUT,
  headers: {
    'Content-Type': API_CONFIG.HEADERS.CONTENT_TYPE,
  },
});

request.interceptors.request.use(
  (config: InternalAxiosRequestConfig) => {
    const token = getAccessToken();
    if (token && config.headers) {
      config.headers.Authorization = `${API_CONFIG.HEADERS.AUTH_PREFIX} ${token}`;
    }
    return config;
  },
  (error: AxiosError) => Promise.reject(new NetworkError(error)),
);

request.interceptors.response.use(
  (response: AxiosResponse) => response,
  (error: AxiosError) => {
    if (error.code === 'ECONNABORTED') {
      return Promise.reject(new TimeoutError(error));
    }
    if (!error.response) {
      return Promise.reject(new NetworkError(error));
    }
    const { status, data } = error.response as AxiosResponse<BaseError>;
    switch (status) {
      case API_CONFIG.STATUS.UNAUTHORIZED:
        return Promise.reject(new UnauthorizedError(error));
      case API_CONFIG.STATUS.CONFLICT:
        return Promise.reject(new ConflictError(error));
      default:
        return Promise.reject(new APIError(status, data?.message ?? `[${status}] ${ERROR_MESSAGES.DEFAULT}`, error));
    }
  },
);

export default request;
