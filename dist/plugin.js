var capacitorTLAppleWallet = (function (exports, core) {
    'use strict';

    /**
     * Constant representing the add action for Apple Wallet.
     * @constant {number}
     */
    const APPLE_WALLET_ACTION_TYPE_ADD = 0;
    /**
     * Constant representing the pay action for Apple Wallet.
     * @constant {number}
     */
    const APPLE_WALLET_ACTION_TYPE_PAY = 1;

    const TLAppleWallet = core.registerPlugin('TLAppleWallet', {
        web: () => Promise.resolve().then(function () { return web; }).then(m => new m.TLAppleWalletWeb()),
    });

    class TLAppleWalletWeb extends core.WebPlugin {
        initialize() {
            throw new Error('Method not implemented on Web !');
        }
        getActionsAvailableForCardSuffix(_options) {
            throw new Error('Method not implemented on Web !');
        }
        openCard(_options) {
            throw new Error('Method not implemented on Web !');
        }
        startAddPaymentPass(_options) {
            throw new Error('Method not implemented on Web !');
        }
        completeAddPaymentPass(_options) {
            throw new Error('Method not implemented on Web !');
        }
    }

    var web = /*#__PURE__*/Object.freeze({
        __proto__: null,
        TLAppleWalletWeb: TLAppleWalletWeb
    });

    exports.APPLE_WALLET_ACTION_TYPE_ADD = APPLE_WALLET_ACTION_TYPE_ADD;
    exports.APPLE_WALLET_ACTION_TYPE_PAY = APPLE_WALLET_ACTION_TYPE_PAY;
    exports.TLAppleWallet = TLAppleWallet;

    Object.defineProperty(exports, '__esModule', { value: true });

    return exports;

})({}, capacitorExports);
//# sourceMappingURL=plugin.js.map
