import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(TLAppleWalletPlugin)
public class TLAppleWalletPlugin: CAPPlugin, CAPBridgedPlugin {
	
	// MARK: - Variables
	public let identifier = "TLAppleWalletPlugin"
	public let jsName = "TLAppleWallet"
	public let pluginMethods: [CAPPluginMethod] = [
		CAPPluginMethod(name: "initialize", returnType: CAPPluginReturnNone),
		CAPPluginMethod(name: "getActionsAvailableForCardSuffix", returnType: CAPPluginReturnPromise),
		CAPPluginMethod(name: "openCard", returnType: CAPPluginReturnNone),
		CAPPluginMethod(name: "startAddPaymentPass", returnType: CAPPluginReturnPromise),
		CAPPluginMethod(name: "completeAddPaymentPass", returnType: CAPPluginReturnNone)
	]
	
	private let implementation = TLAppleWallet()
	
	// MARK: - Init
	@objc
	public func initialize(_ call: CAPPluginCall) {
		do {
			try self.implementation.initialize()
			call.resolve()
		} catch {
			call.reject(error.localizedDescription)
		}
	}
	
	@objc
	func getActionsAvailableForCardSuffix(_ call: CAPPluginCall) {
		guard let cardSuffix = call.getString("cardSuffix")
		else {
			call.reject("cardSuffix PARAMETER IS NOT PASSED !")
			return
		}
		
		do {
			let actions = try self.implementation.getActionsAvailable(for: cardSuffix)
			call.resolve(["actions": actions])
		} catch {
			call.reject(error.localizedDescription)
		}
	}
	
	@objc
	func openCard(_ call: CAPPluginCall) {
		guard let cardSuffix = call.getString("cardSuffix")
		else {
			call.reject("cardSuffix PARAMETER IS NOT PASSED !")
			return
		}
		
		DispatchQueue.main.async { [implementation] in
			do {
				try implementation.openCard(cardSuffix: cardSuffix)
			} catch {
				call.reject(error.localizedDescription)
			}
		}
	}
	
	@objc
	func startAddPaymentPass(_ call: CAPPluginCall) {
		DispatchQueue.main.async { [implementation, bridge] in
			do {
				try implementation.startAddPaymentPass(call: call, bridge: bridge)
			} catch {
				call.reject(error.localizedDescription)
			}
		}
	}
	
	@objc
	public func completeAddPaymentPass(_ call: CAPPluginCall) {
		do {
			try self.implementation.completeAddPaymentPass(call: call)
		} catch {
			call.reject(error.localizedDescription)
		}
	}
}
