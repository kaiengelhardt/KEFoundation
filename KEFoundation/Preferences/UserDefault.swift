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
import Observation

/// Based on this [blog post](https://www.avanderlee.com/swift/appstorage-explained/).
@available(iOS 17.0, macOS 14.0, macCatalyst 17.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *)
@propertyWrapper
public struct UserDefault<Value: UserDefaultValue, PreferenceContainer: Preferences>: Sendable {
	public let key: String
	public let defaultValue: Value
	private let observationRegistrar = ObservationRegistrar()

	@available(*, unavailable, message: "@UserDefault can only be applied to classes conforming to Preferences")
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
			let storage = instance[keyPath: storageKeyPath]
			storage.observationRegistrar.access(instance, keyPath: wrappedKeyPath)
			let key = storage.key
			let defaultValue = storage.defaultValue
			let value = Value.readValue(forKey: key, from: instance.userDefaults)
			let result: Value = if value is any OptionalType && value.flattened == nil {
				defaultValue
			} else {
				value ?? defaultValue
			}
			return result
		}
		set {
			let storage = instance[keyPath: storageKeyPath]
			storage.observationRegistrar.withMutation(of: instance, keyPath: wrappedKeyPath) {
				do {
					try newValue.writeValue(forKey: storage.key, to: instance.userDefaults)
				} catch {
					print("Failed to write value \(newValue) for key \(storage.key) to UserDefaults!\n\(error).")
				}
			}
		}
	}
}

@available(iOS 17.0, macOS 14.0, macCatalyst 17.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *)
extension UserDefault where Value: OptionalType {
	init(_ key: String) {
		self.init(wrappedValue: .none, key)
	}
}
