import { WebPlugin } from '@capacitor/core';

import type { ProvisioningDataRequest, ProvisioningDataResponse, ProvisioningFinalDataRequest, TLAppleWalletPlugin } from './definitions';

export class TLAppleWalletWeb extends WebPlugin implements TLAppleWalletPlugin {

  initialize(): Promise<void> {
    throw new Error('Method not implemented on Web !');
  }

  getActionsAvailableForCardSuffix(_options: { cardSuffix: string; }): Promise<{ actions: number[]; }> {
    throw new Error('Method not implemented on Web !');
  }

  openCard(_options: { cardSuffix: string; }): Promise<void> {
    throw new Error('Method not implemented on Web !');
  }

  startAddPaymentPass(_options: ProvisioningDataRequest): Promise<ProvisioningDataResponse> {
    throw new Error('Method not implemented on Web !');
  }
  completeAddPaymentPass(_options: ProvisioningFinalDataRequest): Promise<void> {
    throw new Error('Method not implemented on Web !');
  }
}
