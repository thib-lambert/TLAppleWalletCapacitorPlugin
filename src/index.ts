import { registerPlugin } from '@capacitor/core';

import type { TLAppleWalletPlugin } from './definitions';

const TLAppleWallet = registerPlugin<TLAppleWalletPlugin>('TLAppleWallet', {
  web: () => import('./web').then(m => new m.TLAppleWalletWeb()),
});

export * from './definitions';
export { TLAppleWallet };
