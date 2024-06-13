import Foundation

enum ProvisioningDataError: String, LocalizedError {
	
	case cardholderName,
		 localizedDescription,
		 paymentNetwork,
		 invalidPaymentNetwork,
		 encryptionScheme,
		 invalidEncryptionScheme,
		 dataNil
	
	var errorDescription: String? {
		switch self {
		case .invalidPaymentNetwork: return "paymentNetwork PARAMETER IS INVALID !"
		case .invalidEncryptionScheme: return "encryptionScheme PARAMETER IS INVALID !"
		case .dataNil: return "PARAMETERS IS REQUIRED !"
		default: return "\(self.rawValue) PARAMETER IS REQUIRED !"
		}
	}
}