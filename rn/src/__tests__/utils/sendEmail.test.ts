// sendSupportEmail 유틸 테스트 — 발신자 정보를 담은 mailto URL로 Linking 호출
import { Linking } from 'react-native';

import { sendSupportEmail } from '@/screens/home/setting/Setting/utils/sendEmail';

describe('sendSupportEmail', () => {
  it('opens a mailto URL with the sender info encoded', async () => {
    const spy = jest.spyOn(Linking, 'openURL').mockResolvedValue(true);

    await sendSupportEmail({ nickname: '데모', account: 'demo@example.com' });

    expect(spy).toHaveBeenCalledTimes(1);
    const url = spy.mock.calls[0][0];
    expect(url.startsWith('mailto:')).toBe(true);

    const decoded = decodeURIComponent(url);
    expect(decoded).toContain('[새싹일기] 문의');
    expect(decoded).toContain('데모(demo@example.com)');

    spy.mockRestore();
  });
});
