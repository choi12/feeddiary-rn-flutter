import Config from 'react-native-config';

import { isAndroid } from './platform';

export const GOOGLE_CLIENT_ID = isAndroid ? Config.GOOGLE_CLIENT_ID_ANDROID : Config.GOOGLE_CLIENT_ID_IOS;
