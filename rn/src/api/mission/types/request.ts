import { Mission } from '@/types/mission';

export interface CompleteMissionRequest {
  mission_idx: number;
  type: Mission;
}
