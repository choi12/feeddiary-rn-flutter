import { ParamListBase, RouteProp, useRoute } from '@react-navigation/native';

import { StackParamList } from '@/navigation/MainNavigation/types';

/**
 * @throws {Error} Navigation context 외부에서 호출 시 에러
 * @example
 * const {params: { diaryIdx }} = useTypedRoute<'DiaryDetails'>();
 */
function useTypedRoute<
  RouteName extends keyof ParamList,
  ParamList extends ParamListBase = StackParamList,
>(): RouteProp<ParamList, RouteName> {
  try {
    const route = useRoute<RouteProp<ParamList, RouteName>>();

    return route;
  } catch (error) {
    throw new Error('useTypedRoute must be used within a Navigation context');
  }
}

export default useTypedRoute;
