//
//  Created by Kai Engelhardt on 25.12.21
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

/// Taken from this [Stackoverflow answer](https://stackoverflow.com/a/67133582/980386).
extension Publisher {
	/// Includes the current element as well as the previous element from the upstream publisher in a tuple
	/// where the previous element is optional.
	/// The first time the upstream publisher emits an element, the previous element will be `nil`.
	///
	///     let range = (1...5)
	///     cancellable = range.publisher
	///         .withPrevious()
	///         .sink { print ("(\($0.previous), \($0.current))", terminator: " ") }
	///      // Prints: "(nil, 1) (Optional(1), 2) (Optional(2), 3) (Optional(3), 4) (Optional(4), 5) ".
	///
	/// - Returns: A publisher of a tuple of the previous and current elements from the upstream publisher.
	public func withPrevious() -> AnyPublisher<(previous: Output?, current: Output), Failure> {
		scan((Output?, Output)?.none) { ($0?.1, $1) }
			.compactMap { $0 }
			.eraseToAnyPublisher()
	}

	/// Includes the current element as well as the previous element from the upstream publisher in a tuple
	/// where the previous element is not optional.
	/// The first time the upstream publisher emits an element, the previous element will be the `initialPreviousValue`.
	///
	///     let range = (1...5)
	///     cancellable = range.publisher
	///         .withPrevious(0)
	///         .sink { print ("(\($0.previous), \($0.current))", terminator: " ") }
	///      // Prints: "(0, 1) (1, 2) (2, 3) (3, 4) (4, 5) ".
	///
	/// - Parameter initialPreviousValue: The initial value to use as the "previous" value
	/// when the upstream publisher emits for the first time.
	/// - Returns: A publisher of a tuple of the previous and current elements from the upstream publisher.
	public func withPrevious(
		_ initialPreviousValue: Output
	) -> AnyPublisher<(previous: Output, current: Output), Failure> {
		scan((initialPreviousValue, initialPreviousValue)) { ($0.1, $1) }.eraseToAnyPublisher()
	}
}
