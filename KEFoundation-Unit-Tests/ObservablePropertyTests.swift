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
@testable import KEFoundation
import XCTest

class ObservablePropertyTests: XCTestCase {
	private var object: ObservablePropertyMockObject!
	private var cancellables: Set<AnyCancellable> = []

	override func setUpWithError() throws {
		try super.setUpWithError()
		object = ObservablePropertyMockObject(value: "Test")
		cancellables = []
	}

	func testSingleElement() {
		XCTAssertEqual(object.observableValue, "Test")
	}

	func testInitialValueObserved() {
		object.$observableValue.didSet
			.sink { newValue in
				XCTAssertEqual(newValue, "Test")
				XCTAssertEqual(newValue, self.object.observableValue)
			}
			.store(in: &cancellables)

		object.$publishedValue
			.sink { newValue in
				XCTAssertEqual(newValue, "Test")
				XCTAssertEqual(newValue, self.object.publishedValue)
			}
			.store(in: &cancellables)
	}

	func testSubsequentValueObserved() {
		object.observableValue = "Test 2"
		object.publishedValue = "Test 2"

		object.$observableValue.didSet
			.sink { newValue in
				XCTAssertEqual(newValue, "Test 2")
			}
			.store(in: &cancellables)

		object.$publishedValue
			.sink { newValue in
				XCTAssertEqual(newValue, "Test 2")
			}
			.store(in: &cancellables)
	}

	func testObservableValueIsAlreadyUpToDateWhenSinkIsCalled() {
		object.$observableValue.didSet
			.dropFirst()
			.sink { newValue in
				XCTAssertEqual(newValue, "Wurst")
				XCTAssertEqual(self.object.observableValue, "Wurst")
			}
			.store(in: &cancellables)
		object.observableValue = "Wurst"
	}

	func testPublishedValueIsNotUpToDateYetWhenSinkIsCalled() {
		object.$publishedValue
			.dropFirst()
			.sink { newValue in
				XCTAssertEqual(newValue, "Wurst")
				XCTAssertEqual(self.object.publishedValue, "Test")
			}
			.store(in: &cancellables)
		object.publishedValue = "Wurst"
	}

	func testMultipleValuesAreObservedProperly() {
		var values: [String] = []
		object.$observableValue.didSet
			.sink { value in
				values.append(value)
			}
			.store(in: &cancellables)
		object.observableValue = "1"
		object.observableValue = "2"
		object.observableValue = "3"
		XCTAssertEqual(values, ["Test", "1", "2", "3"])
	}

	func testMockObjectObjectWillChangeIsSent() {
		var objectWillChangeCalled = false
		object.objectWillChange
			.sink {
				objectWillChangeCalled = true
			}
			.store(in: &cancellables)

		XCTAssertFalse(objectWillChangeCalled)
		object.publishedValue = "1"
		XCTAssertTrue(objectWillChangeCalled)
		objectWillChangeCalled = false
		object.observableValue = "1"
		XCTAssertTrue(objectWillChangeCalled)
	}

	func testPlainMockObjectPropertiesAreObservable() {
		let object = PlainMockObject(value: "1")
		var values: [String] = []
		object.$value.didSet
			.sink { value in
				values.append(value)
			}
			.store(in: &cancellables)
		object.value = "2"
		object.value = "3"
		XCTAssertEqual(values, ["1", "2", "3"])
	}
}

private class ObservablePropertyMockObject: ObservableObject {
	@ObservableProperty var observableValue: String
	@Published var publishedValue: String

	init(value: String) {
		observableValue = value
		publishedValue = value
	}
}

private class PlainMockObject {
	@ObservableProperty var value: String

	init(value: String) {
		self.value = value
	}
}
