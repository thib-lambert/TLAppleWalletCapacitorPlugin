import Foundation

enum ApplePayError: LocalizedError {
	
	case passLibraryUnavailable,
		 watchConnectNotSupported,
		 cardNotFound
	
	var errorDescription: String? {
		switch self {
		case .passLibraryUnavailable:
			return "PKPassLibrary is not available on this device"
			
		case .watchConnectNotSupported:
			return "WCSession is not supported"
			
		case .cardNotFound:
			return "Card not found"
		}
	}
}