import notifee, { AndroidImportance } from '@notifee/react-native';
import { z } from 'zod';

import type { RemoteMessage } from './types';

const PushPayloadSchema = z.object({
  title: z.string(),
  body: z.string(),
  diaryIdx: z.string(),
});

export const displayNotification = async (message: RemoteMessage) => {
  if (!message.data?.notifee) return;

  let parsedJson: unknown;
  try {
    parsedJson = JSON.parse(message.data.notifee as string);
  } catch {
    return;
  }

  const result = PushPayloadSchema.safeParse(parsedJson);
  if (!result.success) return;

  const pushPayload = result.data;

  const channel = await notifee.createChannel({
    id: 'feeddiary',
    name: 'feeddiary',
    importance: AndroidImportance.HIGH,
  });

  await notifee.displayNotification({
    title: pushPayload.title,
    body: pushPayload.body,
    data: {
      diaryIdx: pushPayload.diaryIdx,
    },
    android: {
      channelId: channel,
      smallIcon: 'push_icon',
      pressAction: { id: 'default' },
    },
    ios: {
      critical: true, // 무음 모드에서도 알림 표시
    },
  });
};
