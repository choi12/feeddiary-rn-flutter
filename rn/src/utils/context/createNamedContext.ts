import { Context, createContext } from 'react';

type NamedContext<T> = Context<T> & { displayName: string };

/**
 * displayName을 포함한 Context를 생성
 * - 디버깅 시 Context를 쉽게 식별하기 위함
 *
 * @example
 * const UserContext = createNamedContext<UserContext | undefined>('UserContext', undefined);
 */
export function createNamedContext<T>(name: string, initValue: T): NamedContext<T> {
  const context = createContext(initValue);
  context.displayName = name;

  return context as NamedContext<T>;
}
