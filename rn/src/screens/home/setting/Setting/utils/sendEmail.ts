import { Linking, Platform } from 'react-native';
import Config from 'react-native-config';

import { version as appVersion } from '../../../../../../package.json';
import { EmailSender } from '../types';

export const sendSupportEmail = async (senderInfo: EmailSender) => {
  const subject = encodeURIComponent('[새싹일기] 문의');
  const body = encodeURIComponent(
    `${senderInfo.nickname}(${senderInfo.account})
Version: ${appVersion} (${Platform.OS})
--------------------------------------------------

(문의 내용을 작성해 주세요.)
`,
  );

  const url = `mailto:${Config.EMAIL_ADDRESS}?subject=${subject}&body=${body}`;
  await Linking.openURL(url);
};
