import Config from 'react-native-config';

import { isAndroid } from './platform';

export const STORE_URL = (isAndroid ? Config.GOOGLE_PLAY_STORE_LINK : Config.APPLE_APP_STORE_LINK) ?? '';
