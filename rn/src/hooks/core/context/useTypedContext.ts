import { Context, useContext } from 'react';

/**
 * @throws {Error} Provider 없이 사용될 경우 에러
 * @example
 * const useUserContext = useTypedContext(UserContext);
 */
function useTypedContext<T>(context: Context<T | undefined>): T {
  const contextValue = useContext(context);
  const contextName = context.displayName;
  const errorMessage = `use${contextName} must be used within a ${contextName}Provider`;

  if (contextValue === undefined) {
    throw new Error(errorMessage);
  }

  return contextValue;
}

export default useTypedContext;
