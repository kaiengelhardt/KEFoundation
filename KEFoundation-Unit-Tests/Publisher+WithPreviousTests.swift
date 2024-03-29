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
@testable import KEFoundation
import XCTest

class Publisher_WithPreviousTests: XCTestCase {
	private var cancellables: Set<AnyCancellable> = []

	override func setUpWithError() throws {
		try super.setUpWithError()
		cancellables = []
	}

	func testNilInitialPreviousValue() {
		let box = Box(number: 1)
		box.$number.didSet
			.withPrevious()
			.sink { previousNumber, number in
				XCTAssertNil(previousNumber)
				XCTAssertEqual(box.number, 1)
			}
			.store(in: &cancellables)
	}

	func testExplicitInitialPreviousValue() {
		let box = Box(number: 1)
		box.$number.didSet
			.withPrevious(0)
			.sink { previousNumber, number in
				XCTAssertEqual(previousNumber, 0)
				XCTAssertEqual(box.number, 1)
			}
			.store(in: &cancellables)
	}

	func testSubsequentPreviousValue() {
		let box = Box(number: 1)
		box.$number.didSet
			.withPrevious()
			.dropFirst()
			.sink { previousNumber, number in
				XCTAssertEqual(previousNumber, 1)
				XCTAssertEqual(box.number, 2)
			}
			.store(in: &cancellables)
		box.number = 2
	}
}

private class Box: ObservableObject {
	@ObservableProperty var number: Int

	init(number: Int) {
		self.number = number
	}
}
