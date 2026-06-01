import { ERROR_MESSAGES } from '@/constants';

export class BaseError extends Error {
  constructor(
    message: string,
    name: string,
    public originalError?: unknown,
  ) {
    super(message);
    this.name = name;

    Object.setPrototypeOf(this, new.target.prototype);

    if (Error.captureStackTrace) {
      Error.captureStackTrace(this, this.constructor);
    }
  }
}

export class NetworkError extends BaseError {
  constructor(originalError?: unknown) {
    super(ERROR_MESSAGES.NETWORK, 'NetworkError', originalError);
  }
}

export class TimeoutError extends BaseError {
  constructor(originalError?: unknown) {
    super(ERROR_MESSAGES.TIMEOUT, 'TimeoutError', originalError);
  }
}

export class UnauthorizedError extends BaseError {
  constructor(originalError?: unknown) {
    super(ERROR_MESSAGES.UNAUTHORIZED, 'UnauthorizedError', originalError);
  }
}

export class ConflictError extends BaseError {
  constructor(originalError?: unknown) {
    super(ERROR_MESSAGES.CONFLICT, 'ConflictError', originalError);
  }
}

export class APIError extends BaseError {
  constructor(
    public statusCode: number,
    message: string,
    originalError?: unknown,
  ) {
    super(message, 'APIError', originalError);
  }
}
