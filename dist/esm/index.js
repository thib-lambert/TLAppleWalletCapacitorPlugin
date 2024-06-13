import { registerPlugin } from '@capacitor/core';
const TLAppleWallet = registerPlugin('TLAppleWallet', {
    web: () => import('./web').then(m => new m.TLAppleWalletWeb()),
});
export * from './definitions';
export { TLAppleWallet };
//# sourceMappingURL=index.js.map