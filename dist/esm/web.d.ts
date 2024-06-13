import { WebPlugin } from '@capacitor/core';
import type { ProvisioningDataRequest, ProvisioningDataResponse, ProvisioningFinalDataRequest, TLAppleWalletPlugin } from './definitions';
export declare class TLAppleWalletWeb extends WebPlugin implements TLAppleWalletPlugin {
    initialize(): Promise<void>;
    getActionsAvailableForCardSuffix(_options: {
        cardSuffix: string;
    }): Promise<{
        actions: number[];
    }>;
    openCard(_options: {
        cardSuffix: string;
    }): Promise<void>;
    startAddPaymentPass(_options: ProvisioningDataRequest): Promise<ProvisioningDataResponse>;
    completeAddPaymentPass(_options: ProvisioningFinalDataRequest): Promise<void>;
}
