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

import Combine
import Foundation
import SwiftUI

/// Based on this [blog post](https://www.avanderlee.com/swift/appstorage-explained/).
@propertyWrapper
public struct Preference<Value, PreferenceContainer: Preferences>: DynamicProperty {
	@ObservedObject private var preferencesObserver: PublisherObservableObject
	private let keyPath: ReferenceWritableKeyPath<PreferenceContainer, Value>
	private let preferences: PreferenceContainer

	public var wrappedValue: Value {
		get {
			preferences[keyPath: keyPath]
		}
		nonmutating set {
			preferences[keyPath: keyPath] = newValue
		}
	}

	public init(
		_ keyPath: ReferenceWritableKeyPath<PreferenceContainer, Value>,
		preferences: PreferenceContainer = .default
	) {
		self.keyPath = keyPath
		self.preferences = preferences

		let publisher = preferences
			.preferencesChangedSubject
			.filter { changedKeyPath in
				changedKeyPath == keyPath
			}
			.map { _ in () }
			.eraseToAnyPublisher()
		preferencesObserver = .init(publisher: publisher)
	}

	public var projectedValue: Binding<Value> {
		return Binding(
			get: {
				wrappedValue
			},
			set: {
				wrappedValue = $0
			}
		)
	}
}

private class PublisherObservableObject: ObservableObject {
	var subscriber: AnyCancellable?

	init(publisher: AnyPublisher<Void, Never>) {
		subscriber = publisher.sink(receiveValue: { [weak self] _ in
			self?.objectWillChange.send()
		})
	}
}
