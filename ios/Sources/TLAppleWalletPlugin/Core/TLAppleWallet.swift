import Foundation
import PassKit
import WatchConnectivity
import Capacitor

@objc
public class TLAppleWallet: NSObject {
	
	// MARK: - Variables
	private var passLibrary: PKPassLibrary?
	private lazy var watchSession: WCSession = {
		let session = WCSession.default
		return session
	}()
	
	private var isPairedWithWatch: Bool {
		self.watchSession.isPaired
	}
	
	private var startAddPaymentPassCallbackId: String?
	private var completeAddPaymentPassCallbackId: String?
	private var bridge: (any CAPBridgeProtocol)?
	private var provisioningHandler: ((PKAddPaymentPassRequest) -> Void)?
	
	// MARK: - Init
	@objc
	public func initialize() throws {
		guard PKPassLibrary.isPassLibraryAvailable() && PKAddPaymentPassViewController.canAddPaymentPass()
		else { throw ApplePayError.passLibraryUnavailable }
		
		self.passLibrary = PKPassLibrary()
		
		if WCSession.isSupported() {
			self.watchSession.activate()
		}
	}
	
	// MARK: - Utils
	@objc
	public func getActionsAvailable(for cardSuffix: String?) throws -> [Int] {
		guard let cardSuffix else { return [] }
		
		var buttons: [Int] = []
		if self.canAddPass(cardSuffix: cardSuffix) {
			buttons.append(0) // ADD
		}
		
		if self.canPayWithPass(cardSuffix: cardSuffix) {
			buttons.append(1) // PAY
		}
		
		return buttons
	}
	
	private func canAddPass(cardSuffix: String?) -> Bool {
		// Able to add to iPhone
		if self.fetchIphonePass(cardSuffix: cardSuffix) == nil {
			return true
		}
		
		// Able to add to Watch
		if #available(iOS 13.4, *) {
			if let iPhonePassIdentifier = self.fetchIphonePass(cardSuffix: cardSuffix)?.secureElementPass?.primaryAccountIdentifier,
			   self.passLibrary?.canAddSecureElementPass(primaryAccountIdentifier: iPhonePassIdentifier) ?? false,
			   self.fetchWatchPass(cardSuffix: cardSuffix) == nil {
				return true
			}
		} else {
			if let iPhonePassIdentifier = self.fetchIphonePass(cardSuffix: cardSuffix)?.paymentPass?.primaryAccountIdentifier,
			   self.passLibrary?.canAddPaymentPass(withPrimaryAccountIdentifier: iPhonePassIdentifier) ?? false,
			   self.fetchWatchPass(cardSuffix: cardSuffix) == nil {
				return true
			}
		}
		
		return false
	}
	
	private func canPayWithPass(cardSuffix: String?) -> Bool {
		self.fetchIphonePass(cardSuffix: cardSuffix) != nil
	}
	
	private func fetchIphonePass(cardSuffix: String?) -> PKPass? {
		if #available(iOS 13.4, *) {
			return self.passLibrary?
				.passes()
				.first {
					$0.secureElementPass?.primaryAccountNumberSuffix == cardSuffix
				}
		} else {
			return self.passLibrary?
				.passes()
				.first {
					$0.paymentPass?.primaryAccountNumberSuffix == cardSuffix
				}
		}
	}
	
	private func fetchWatchPass(cardSuffix: String?) -> PKPass? {
		guard self.isPairedWithWatch else { return nil }
		
		if #available(iOS 13.4, *) {
			return self.passLibrary?
				.remoteSecureElementPasses
				.first {
					$0.secureElementPass?.primaryAccountNumberSuffix == cardSuffix
				}
		} else {
			return self.passLibrary?
				.remotePaymentPasses()
				.first {
					$0.paymentPass?.primaryAccountNumberSuffix == cardSuffix
				}
		}
	}
	
	@objc
	func openCard(cardSuffix: String?) throws {
		if #available(iOS 13.4, *) {
			guard let currentPass = self.fetchIphonePass(cardSuffix: cardSuffix),
				  let paymentPass = currentPass.secureElementPass
			else { throw ApplePayError.cardNotFound }
			
			if paymentPass.passActivationState == .requiresActivation,
			   let passUrl = paymentPass.passURL {
				UIApplication.shared.open(passUrl, options: [:], completionHandler: nil)
			} else {
				self.passLibrary?.present(paymentPass)
			}
		} else {
			guard let currentPass = self.fetchIphonePass(cardSuffix: cardSuffix),
				  let paymentPass = currentPass.paymentPass
			else { throw ApplePayError.cardNotFound }
			
			if paymentPass.passActivationState == .requiresActivation,
			   let passUrl = paymentPass.passURL {
				UIApplication.shared.open(passUrl, options: [:], completionHandler: nil)
			} else {
				self.passLibrary?.present(paymentPass)
			}
		}
	}
	
	// MARK: - Provisioning
	@objc
	func startAddPaymentPass(call: CAPPluginCall,
							 bridge: (any CAPBridgeProtocol)?) throws {
		let cardData = try ProvisioningData(data: call.options)
		self.bridge = bridge
		self.startAddPaymentPassCallbackId = call.callbackId
		
		let request = PKAddPaymentPassRequestConfiguration(encryptionScheme: cardData.encryptionScheme)
		request?.cardholderName = cardData.cardholderName
		request?.localizedDescription = cardData.localizedDescription
		request?.primaryAccountSuffix = cardData.primaryAccountSuffix
		request?.style = .payment
		request?.paymentNetwork = cardData.paymentNetwork
		
		// This info is needed to prevent PKAddPaymentPassViewController to propose already added pass (phone or watch)
		if #available(iOS 13.4, *) {
			if let pass = self.fetchIphonePass(cardSuffix: cardData.primaryAccountSuffix) ?? self.fetchWatchPass(cardSuffix: cardData.primaryAccountSuffix),
			   let primaryAccountIdentifier = pass.secureElementPass?.primaryAccountIdentifier {
				request?.primaryAccountIdentifier = primaryAccountIdentifier
			}
		} else {
			if let pass = self.fetchIphonePass(cardSuffix: cardData.primaryAccountSuffix) ?? self.fetchWatchPass(cardSuffix: cardData.primaryAccountSuffix),
			   let primaryAccountIdentifier = pass.paymentPass?.primaryAccountIdentifier {
				request?.primaryAccountIdentifier = primaryAccountIdentifier
			}
		}
		
		guard let request,
			  let addPaymentPassViewController = PKAddPaymentPassViewController(requestConfiguration: request, delegate: self),
			  let topViewController = self.bridge?.viewController
		else { throw ProvisioningError() }
		
		self.bridge?.saveCall(call)
		topViewController.present(addPaymentPassViewController, animated: true)
	}
	
	@objc
	func completeAddPaymentPass(call: CAPPluginCall) throws {
		guard let options = call.options else { throw AddPaymentError.dataNil }
		
		guard let encryptedPassData = options["encryptedPassData"] as? String,
			  !encryptedPassData.isEmpty
		else { throw AddPaymentError.encryptedPassData }
		
		guard let ephemeralPublicKey = options["ephemeralPublicKey"] as? String,
			  !ephemeralPublicKey.isEmpty
		else { throw AddPaymentError.ephemeralPublicKey }
		
		guard let activationData = options["activationData"] as? String,
			  !activationData.isEmpty
		else { throw AddPaymentError.activationData }
		
		self.completeAddPaymentPassCallbackId = call.callbackId
		
		let requestPayPass = PKAddPaymentPassRequest()
		requestPayPass.encryptedPassData = Data(hex: encryptedPassData)
		requestPayPass.ephemeralPublicKey = Data(hex: ephemeralPublicKey)
		requestPayPass.activationData = Data(hex: activationData)
		
		self.provisioningHandler?(requestPayPass)
	}
}

// MARK: - PKAddPaymentPassViewControllerDelegate
extension TLAppleWallet: PKAddPaymentPassViewControllerDelegate {
	
	public func addPaymentPassViewController(_ controller: PKAddPaymentPassViewController,
											 generateRequestWithCertificateChain certificates: [Data],
											 nonce: Data,
											 nonceSignature: Data,
											 completionHandler handler: @escaping (PKAddPaymentPassRequest) -> Void) {
		guard let startAddPaymentPassCallbackId,
			  let call = self.bridge?.savedCall(withID: startAddPaymentPassCallbackId)
		else { return }
		
		self.provisioningHandler = handler
		
		call.resolve([
			"nonce": nonce.hexadecimal,
			"nonceSignature": nonceSignature.hexadecimal,
			"certificates": certificates.map { $0.hexadecimal }
		])
		
		self.startAddPaymentPassCallbackId = nil
		self.bridge?.releaseCall(call)
	}
	
	public func addPaymentPassViewController(_ controller: PKAddPaymentPassViewController,
											 didFinishAdding pass: PKPaymentPass?,
											 error: (any Error)?) {
		controller.dismiss(animated: true) { [weak self] in
			guard let completeAddPaymentPassCallbackId = self?.completeAddPaymentPassCallbackId,
				  let call = self?.bridge?.savedCall(withID: completeAddPaymentPassCallbackId)
			else { return }
			
			if let error {
				call.reject(error.localizedDescription)
			} else {
				call.resolve()
			}
		}
	}
}