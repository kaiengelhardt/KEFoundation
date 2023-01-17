//
//  Created by Kai Engelhardt on 12.01.23
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

/// Based on this [blog post](https://www.avanderlee.com/swift/appstorage-explained/).
@propertyWrapper
public struct UserDefault<Value: UserDefaultValue, PreferenceContainer: Preferences> {
	public let key: String
	public let defaultValue: Value

	@available(*, unavailable, message: "@Published can only be applied to classes")
	public var wrappedValue: Value {
		get {
			preconditionFailure()
		}
		set {
			preconditionFailure()
		}
	}

	public init(wrappedValue: Value, _ key: String) {
		defaultValue = wrappedValue
		self.key = key
	}

	public static subscript(
		_enclosingInstance instance: PreferenceContainer,
		wrapped wrappedKeyPath: ReferenceWritableKeyPath<PreferenceContainer, Value>,
		storage storageKeyPath: ReferenceWritableKeyPath<PreferenceContainer, Self>
	) -> Value {
		get {
			let key = instance[keyPath: storageKeyPath].key
			let defaultValue = instance[keyPath: storageKeyPath].defaultValue
			let value = Value.readValue(forKey: key, from: instance.userDefaults)
			let result: Value
			if value is any OptionalType && value.flattened == nil {
				result = defaultValue
			} else {
				result = value ?? defaultValue
			}
			return result
		}
		set {
			let key = instance[keyPath: storageKeyPath].key
			do {
				try newValue.writeValue(forKey: key, to: instance.userDefaults)
			} catch {
				print("Failed to write value \(newValue) for key \(key) to UserDefaults!\n\(error).")
			}
			instance.preferencesChangedSubject.send(wrappedKeyPath)
		}
	}
}

extension UserDefault where Value: OptionalType {
	init(_ key: String) {
		self.init(wrappedValue: .none, key)
		print(#function, key)
	}
}
