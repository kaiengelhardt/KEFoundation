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

public protocol OptionalType {
	associatedtype Wrapped

	static var none: Self { get }
	var flattened: Any? { get }
}

// MARK: - Optional + OptionalType

extension Optional: OptionalType {
	/// Flattens nested optionals down to one level. This is useful to check for `nil` on nested optionals.
	///
	/// Based on this [Swift Forums post](https://forums.swift.org/t/challenge-flattening-nested-optionals/24083/4).
	public var flattened: Any? {
		_flattened()
	}
}

private protocol Flattenable {
	func _flattened() -> Any?
}

// MARK: - Optional + Flattenable

extension Optional: Flattenable {
	fileprivate func _flattened() -> Any? {
		switch self {
		case let .some(x as Flattenable):
			return x._flattened()
		case let .some(x):
			return x
		case .none:
			return nil
		}
	}
}
