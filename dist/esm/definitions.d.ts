/**
 * Constant representing the add action for Apple Wallet.
 * @constant {number}
 */
export declare const APPLE_WALLET_ACTION_TYPE_ADD = 0;
/**
 * Constant representing the pay action for Apple Wallet.
 * @constant {number}
 */
export declare const APPLE_WALLET_ACTION_TYPE_PAY = 1;
/**
 * Interface representing the provisioning data response.
 * @interface ProvisioningDataResponse
 */
export interface ProvisioningDataResponse {
    /**
     * Nonce used to secure communications.
     * @type {string}
     */
    nonce: string;
    /**
     * Signature of the nonce for verification.
     * @type {string}
     */
    nonceSignature: string;
    /**
     * List of certificates used for authentication.
     * @type {string[]}
     */
    certificates: string[];
}
/**
 * Interface representing the provisioning data request.
 * @interface ProvisioningDataRequest
 */
export interface ProvisioningDataRequest {
    /**
     * Name of the cardholder.
     * @type {string}
     */
    cardholderName: string;
    /**
     * Localized description of the card.
     * @type {string}
     */
    localizedDescription: string;
    /**
     * Payment network (Visa, MasterCard, etc.).
     * @type {string}
     */
    paymentNetwork: string;
    /**
     * Suffix of the primary account (optional).
     * @type {string}
     * @optional
     */
    primaryAccountSuffix?: string;
}
/**
 * Interface representing the final provisioning data request.
 * @interface ProvisioningFinalDataRequest
 */
export interface ProvisioningFinalDataRequest {
    /**
     * Encrypted card data.
     * @type {string}
     */
    encryptedPassData: string;
    /**
     * Ephemeral public key for encryption.
     * @type {string}
     */
    ephemeralPublicKey: string;
    /**
     * Activation data for the card.
     * @type {string}
     */
    activationData: string;
}
/**
 * Interface representing the Apple Wallet plugin.
 * @interface TLAppleWalletPlugin
 */
export interface TLAppleWalletPlugin {
    /**
     * Initializes the plugin.
     * @returns {Promise<void>} A promise that resolves once initialization is complete.
     */
    initialize(): Promise<void>;
    /**
     * Gets the available actions for a given card suffix.
     * @param {Object} options - The options to get available actions.
     * @param {string} options.cardSuffix - The card suffix.
     * @returns {Promise<{actions: number[]}>} A promise that resolves with the available actions.
     */
    getActionsAvailableForCardSuffix(options: {
        cardSuffix: string;
    }): Promise<{
        actions: number[];
    }>;
    /**
     * Opens the card with the specified suffix.
     * @param {Object} options - The options to open the card.
     * @param {string} options.cardSuffix - The card suffix.
     * @returns {Promise<void>} A promise that resolves once the card is opened.
     */
    openCard(options: {
        cardSuffix: string;
    }): Promise<void>;
    /**
     * Starts the process of adding a payment pass.
     * @param {ProvisioningDataRequest} options - The provisioning data required to add a card.
     * @returns {Promise<ProvisioningDataResponse>} A promise that resolves with the provisioning data response.
     */
    startAddPaymentPass(options: ProvisioningDataRequest): Promise<ProvisioningDataResponse>;
    /**
     * Completes the process of adding a payment pass.
     * @param {ProvisioningFinalDataRequest} options - The final provisioning data required to complete the process.
     * @returns {Promise<void>} A promise that resolves once the provisioning is complete.
     */
    completeAddPaymentPass(options: ProvisioningFinalDataRequest): Promise<void>;
}
