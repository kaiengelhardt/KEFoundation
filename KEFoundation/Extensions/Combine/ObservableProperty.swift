//
//  Created by Kai Engelhardt on 18.11.21
//  Copyright © 2021 Kai Engelhardt. All rights reserved.
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

import Combine
import Foundation

/// A property wrapper similar to `@Published` from the `Combine` framework.
///
/// `@Observable` has a major difference from `@Published`:
/// Whereas`projectedValue` in `@Published` is a publisher that triggers on `willSet`,
/// `projectedValue` here provides two publishers: One for `willSet` and one for `didSet`.
///
/// - Warning: This relies on a non-public feature of Swift:
/// Accessing the enclosed instance from inside a property wrapper.
@propertyWrapper
public struct ObservableProperty<Value> {
	@available(*, unavailable, message: "@Published can only be applied to classes")
	public var wrappedValue: Value {
		get {
			preconditionFailure()
		}
		set {
			preconditionFailure()
		}
	}

	private var storage: Value

	public init(wrappedValue: Value) {
		storage = wrappedValue
		projectedValue = WillSetDidSetPublisher(wrappedValue: wrappedValue)
	}

	public static subscript<T>(
		_enclosingInstance instance: T,
		wrapped wrappedKeyPath: ReferenceWritableKeyPath<T, Value>,
		storage storageKeyPath: ReferenceWritableKeyPath<T, Self>
	) -> Value {
		get {
			instance[keyPath: storageKeyPath].storage
		}
		set {
			if let observableObject = instance as? any ObservableObject {
				let anyPublisher = observableObject.objectWillChange as any Publisher
				if let publisher = anyPublisher as? ObservableObjectPublisher {
					publisher.send()
				}
			}
			instance[keyPath: storageKeyPath].projectedValue.willSet.send(newValue)
			instance[keyPath: storageKeyPath].storage = newValue
			instance[keyPath: storageKeyPath].projectedValue.didSet.send(newValue)
		}
	}

	public private(set) var projectedValue: WillSetDidSetPublisher

	public class WillSetDidSetPublisher {
		public private(set) var willSet: CurrentValueSubject<Value, Never>
		public private(set) var didSet: CurrentValueSubject<Value, Never>

		fileprivate init(wrappedValue: Value) {
			willSet = CurrentValueSubject(wrappedValue)
			didSet = CurrentValueSubject(wrappedValue)
		}
	}
}
