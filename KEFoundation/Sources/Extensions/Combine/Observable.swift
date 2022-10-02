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

import Foundation
import Combine

/// A property wrapper similar to `@Published` from the `Combine` framework.
///
/// `@Observable` has 2 major differences from `@Published`.
/// 1. The publisher is triggered on `didSet` rather than `willSet`.
/// 2. `@Observable` does not work automatically with `ObservableObject`.
/// This can only work once Apple implements referencing the enclosing instance in property wrappers.
@propertyWrapper
public class Observable<Value> {

	public init(wrappedValue: Value) {
		projectedValue = CurrentValueSubject(wrappedValue)
	}

	public var wrappedValue: Value {
		get {
			projectedValue.value
		}
		set {
			projectedValue.value = newValue
		}
	}

	public var projectedValue: CurrentValueSubject<Value, Never>
}
