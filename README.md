# tl-apple-wallet-capacitor-plugin

This plugin allows you to add passes and credit cards to Apple Wallet

## Install

```bash
npm install https://github.com/thib-lambert/TLAppleWalletCapacitorPlugin
npx cap sync
```

## API

<docgen-index>

* [`initialize()`](#initialize)
* [`getActionsAvailableForCardSuffix(...)`](#getactionsavailableforcardsuffix)
* [`openCard(...)`](#opencard)
* [`startAddPaymentPass(...)`](#startaddpaymentpass)
* [`completeAddPaymentPass(...)`](#completeaddpaymentpass)
* [Interfaces](#interfaces)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

Interface representing the Apple Wallet plugin.

### initialize()

```typescript
initialize() => Promise<void>
```

Initializes the plugin.

--------------------


### getActionsAvailableForCardSuffix(...)

```typescript
getActionsAvailableForCardSuffix(options: { cardSuffix: string; }) => Promise<{ actions: number[]; }>
```

Gets the available actions for a given card suffix.

| Param         | Type                                 | Description                             |
| ------------- | ------------------------------------ | --------------------------------------- |
| **`options`** | <code>{ cardSuffix: string; }</code> | - The options to get available actions. |

**Returns:** <code>Promise&lt;{ actions: number[]; }&gt;</code>

--------------------


### openCard(...)

```typescript
openCard(options: { cardSuffix: string; }) => Promise<void>
```

Opens the card with the specified suffix.

| Param         | Type                                 | Description                     |
| ------------- | ------------------------------------ | ------------------------------- |
| **`options`** | <code>{ cardSuffix: string; }</code> | - The options to open the card. |

--------------------


### startAddPaymentPass(...)

```typescript
startAddPaymentPass(options: ProvisioningDataRequest) => Promise<ProvisioningDataResponse>
```

Starts the process of adding a payment pass.

| Param         | Type                                                                        | Description                                     |
| ------------- | --------------------------------------------------------------------------- | ----------------------------------------------- |
| **`options`** | <code><a href="#provisioningdatarequest">ProvisioningDataRequest</a></code> | - The provisioning data required to add a card. |

**Returns:** <code>Promise&lt;<a href="#provisioningdataresponse">ProvisioningDataResponse</a>&gt;</code>

--------------------


### completeAddPaymentPass(...)

```typescript
completeAddPaymentPass(options: ProvisioningFinalDataRequest) => Promise<void>
```

Completes the process of adding a payment pass.

| Param         | Type                                                                                  | Description                                                     |
| ------------- | ------------------------------------------------------------------------------------- | --------------------------------------------------------------- |
| **`options`** | <code><a href="#provisioningfinaldatarequest">ProvisioningFinalDataRequest</a></code> | - The final provisioning data required to complete the process. |

--------------------


### Interfaces


#### ProvisioningDataResponse

Interface representing the provisioning data response.

| Prop                 | Type                  | Description                                   |
| -------------------- | --------------------- | --------------------------------------------- |
| **`nonce`**          | <code>string</code>   | Nonce used to secure communications.          |
| **`nonceSignature`** | <code>string</code>   | Signature of the nonce for verification.      |
| **`certificates`**   | <code>string[]</code> | List of certificates used for authentication. |


#### ProvisioningDataRequest

Interface representing the provisioning data request.

| Prop                       | Type                | Description                               |
| -------------------------- | ------------------- | ----------------------------------------- |
| **`cardholderName`**       | <code>string</code> | Name of the cardholder.                   |
| **`localizedDescription`** | <code>string</code> | Localized description of the card.        |
| **`paymentNetwork`**       | <code>string</code> | Payment network (Visa, MasterCard, etc.). |
| **`primaryAccountSuffix`** | <code>string</code> | Suffix of the primary account (optional). |


#### ProvisioningFinalDataRequest

Interface representing the final provisioning data request.

| Prop                     | Type                | Description                          |
| ------------------------ | ------------------- | ------------------------------------ |
| **`encryptedPassData`**  | <code>string</code> | Encrypted card data.                 |
| **`ephemeralPublicKey`** | <code>string</code> | Ephemeral public key for encryption. |
| **`activationData`**     | <code>string</code> | Activation data for the card.        |

</docgen-api>
