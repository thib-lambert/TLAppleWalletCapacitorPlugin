import Foundation

extension Data {
	
	var hexadecimal: String {
		self.map { String(format: "%02x", $0) }.joined()
	}
	
	init?(hex: String) {
		let len = hex.count / 2
		var data = Data(capacity: len)
		var index = hex.startIndex
		
		for _ in 0..<len {
			let i = hex.index(index, offsetBy: 2)
			let bytes = hex[index..<i]
			
			if var num = UInt8(bytes, radix: 16) {
				data.append(&num, count: 1)
			} else {
				return nil
			}
			
			index = i
		}
		
		self = data
	}
}