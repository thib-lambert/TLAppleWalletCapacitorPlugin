package com.thib.lambert.plugin.apple.wallet;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

@CapacitorPlugin(name = "TLAppleWallet")
public class TLAppleWalletPlugin extends Plugin {

    private TLAppleWallet implementation = new TLAppleWallet();

    @PluginMethod
    public void initialize(PluginCall call) {
        call.unimplemented("Method not implemented on Android !");
    }

    @PluginMethod
    public void getActionsAvailableForCardSuffix(PluginCall call) {
        call.unimplemented("Method not implemented on Android !");
    }

    @PluginMethod
    public void openCard(PluginCall call) {
        call.unimplemented("Method not implemented on Android !");
    }

    @PluginMethod
    public void startAddPaymentPass(PluginCall call) {
        call.unimplemented("Method not implemented on Android !");
    }

    @PluginMethod
    public void completeAddPaymentPass(PluginCall call) {
        call.unimplemented("Method not implemented on Android !");
    }
}
