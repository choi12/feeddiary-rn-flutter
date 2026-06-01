import { useNavigation } from '@react-navigation/native';
import { NativeStackNavigationProp } from '@react-navigation/native-stack';

import { StackParamList } from '@/navigation/MainNavigation/types';

function useScreenNavigation() {
  const navigation = useNavigation<NativeStackNavigationProp<StackParamList>>();

  return navigation;
}

export default useScreenNavigation;
