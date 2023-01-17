//
//  Created by Kai Engelhardt on 14.01.23
//  Copyright © 2022 Kai Engelhardt. All rights reserved.
//
//  Distributed under the permissive MIT license
//  Get the latest version from here:
//
//  https://github.com/kaiengelhardt/KEFoundation
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

public protocol UserDefaultValue {
	static func readValue(forKey key: String, from userDefaults: UserDefaults) -> Self?
	func writeValue(forKey key: String, to userDefaults: UserDefaults) throws
}

extension UserDefaultValue {
	public static func readValue(forKey key: String, from userDefaults: UserDefaults) -> Self? {
		return userDefaults.object(forKey: key) as? Self
	}

	public func writeValue(forKey key: String, to userDefaults: UserDefaults) throws {
		userDefaults.set(self, forKey: key)
	}
}

// MARK: - String + UserDefaultValue

extension String: UserDefaultValue {}

// MARK: - Int + UserDefaultValue

extension Int: UserDefaultValue {}

// MARK: - Float + UserDefaultValue

extension Float: UserDefaultValue {}

// MARK: - Double + UserDefaultValue

extension Double: UserDefaultValue {}

// MARK: - CGFloat + UserDefaultValue

// swiftformat:disable:next preferDouble
extension CGFloat: UserDefaultValue {}

// MARK: - Date + UserDefaultValue

extension Date: UserDefaultValue {}

// MARK: - URL + UserDefaultValue

extension URL: UserDefaultValue {
	public static func readValue(forKey key: String, from userDefaults: UserDefaults) -> URL? {
		return userDefaults.url(forKey: key)
	}

	public func writeValue(forKey key: String, to userDefaults: UserDefaults) throws {
		userDefaults.set(self, forKey: key)
	}
}

// MARK: - Data + UserDefaultValue

extension Data: UserDefaultValue {}

// MARK: - Bool + UserDefaultValue

extension Bool: UserDefaultValue {
	public static func readValue(forKey key: String, from userDefaults: UserDefaults) -> Self? {
		guard userDefaults.hasValue(forKey: key) else {
			return nil
		}
		return userDefaults.bool(forKey: key)
	}

	public func writeValue(forKey key: String, to userDefaults: UserDefaults) throws {
		userDefaults.set(self, forKey: key)
	}
}

// MARK: - Array + UserDefaultValue

extension Array: UserDefaultValue where Element: UserDefaultValue {}

// MARK: - Dictionary + UserDefaultValue

extension Dictionary: UserDefaultValue where Key: UserDefaultValue, Value: UserDefaultValue {}

// MARK: - Optional + UserDefaultValue

extension Optional: UserDefaultValue where Wrapped: UserDefaultValue {
	public static func readValue(forKey key: String, from userDefaults: UserDefaults) -> Self? {
		let result = Wrapped.readValue(forKey: key, from: userDefaults).flattened as! Self
		return result
	}

	public func writeValue(forKey key: String, to userDefaults: UserDefaults) throws {
		if let self {
			try self.writeValue(forKey: key, to: userDefaults)
		} else {
			userDefaults.removeObject(forKey: key)
		}
	}
}

extension UserDefaultValue where Self: RawRepresentable, RawValue: UserDefaultValue {
	public static func readValue(forKey key: String, from userDefaults: UserDefaults) -> Self? {
		if let rawValue = RawValue.readValue(forKey: key, from: userDefaults) {
			return Self(rawValue: rawValue)
		} else {
			return nil
		}
	}

	public func writeValue(forKey key: String, to userDefaults: UserDefaults) throws {
		try rawValue.writeValue(forKey: key, to: userDefaults)
	}
}

// MARK: - UUID + UserDefaultValue

extension UUID: UserDefaultValue {
	public static func readValue(forKey key: String, from userDefaults: UserDefaults) -> Self? {
		guard let uuidString = userDefaults.string(forKey: key) else {
			return nil
		}
		return UUID(uuidString: uuidString)
	}

	public func writeValue(forKey key: String, to userDefaults: UserDefaults) throws {
		userDefaults.set(uuidString, forKey: key)
	}
}
