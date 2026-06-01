import { z } from 'zod';

export const AppVersionResponseSchema = z.object({
  app_version_android: z.string(),
  app_version_ios: z.string(),
});

export type AppVersionResponse = z.infer<typeof AppVersionResponseSchema>;
