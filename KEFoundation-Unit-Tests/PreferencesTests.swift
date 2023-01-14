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
@testable import KEFoundation
import XCTest

private let testDefaults = UserDefaults()

private let firstNameKey = "name"
private let defaultFirstName = "Kai"

private let ageKey = "age"
private let defaultAge = 29

private let middleNameKey = "middleName"

private let jobTitleKey = "jobTitle"
private let defaultJobTitle = "Janitor"

final class TestPreferences: Preferences {
	typealias UserDefault<Value> = KEFoundation.UserDefault<Value, TestPreferences>

	static let `default` = TestPreferences()

	var userDefaults: UserDefaults

	var preferencesChangedSubject = PassthroughSubject<AnyKeyPath, Never>()

	init(userDefaults: UserDefaults = testDefaults) {
		self.userDefaults = userDefaults
	}

	@UserDefault(firstNameKey) var firstName = defaultFirstName
	@UserDefault(ageKey) var age = defaultAge
	@UserDefault(middleNameKey) var middleName: String?
	@UserDefault(jobTitleKey) var jobTitle: String? = defaultJobTitle
}

typealias Preference<Value> = KEFoundation.Preference<Value, TestPreferences>

class Object {
	@Preference(\.firstName) var firstName
	@Preference(\.age) var age
	@Preference(\.middleName) var middleName
	@Preference(\.jobTitle) var jobTitle
}

class PreferencesTests: XCTestCase {
	private var observations: Set<AnyCancellable> = []

	override func setUpWithError() throws {
		try super.setUpWithError()
		observations = []
		testDefaults.reset()
	}

	func testDefaultValue() {
		let object = Object()
		XCTAssertEqual(object.firstName, defaultFirstName)
	}

	func testPreferenceIsSavedInUserDefaults() {
		let object = Object()
		object.firstName = "Sarah"
		let name = testDefaults.string(forKey: firstNameKey)
		XCTAssertEqual(object.firstName, name)
	}

	func testPreferenceIsSynchronizedAcrossDeclarations() {
		let object1 = Object()
		let object2 = Object()

		XCTAssertEqual(object1.firstName, defaultFirstName)
		XCTAssertEqual(object2.firstName, defaultFirstName)

		let newName = "Sarah"
		object1.firstName = newName
		XCTAssertEqual(object2.firstName, newName)

		let newName2 = "John"
		object2.firstName = newName2
		XCTAssertEqual(object1.firstName, newName2)
	}

	func testIntergerPreference() {
		let object = Object()
		object.age = 10
		XCTAssertEqual(object.age, 10)
	}

	func testValueForOptionalPreferenceWithNilDefaultValue() {
		let object = Object()
		XCTAssertEqual(object.middleName, nil)

		let newMiddleName = "Philipp"
		object.middleName = newMiddleName
		XCTAssertEqual(object.middleName, newMiddleName)

		object.middleName = nil
		XCTAssertEqual(object.middleName, nil)
	}

	func testValueForOptionalPreferenceWithNonNilDefaultValue() {
		let object = Object()
		XCTAssertEqual(object.jobTitle, defaultJobTitle)

		let newJobTitle = "Taxi Driver"
		object.jobTitle = newJobTitle
		XCTAssertEqual(object.jobTitle, newJobTitle)

		object.jobTitle = nil
		XCTAssertEqual(object.jobTitle, defaultJobTitle)
	}

	func testPublisherPublishesInitialValue() {
		var values: [String] = []
		let object = Object()
		object.$firstName.publisher.sink { firstName in
			values.append(firstName)
		}
		.store(in: &observations)
		XCTAssertEqual(values, [defaultFirstName])
	}

	func testPublisherPublishesSubsequentValues() {
		var values: [String] = []
		let object = Object()
		object.$firstName.publisher.sink { firstName in
			values.append(firstName)
		}
		.store(in: &observations)
		let secondName = "Ralph"
		object.firstName = secondName
		let thirdName = "Lennart"
		object.firstName = thirdName
		XCTAssertEqual(values, [defaultFirstName, secondName, thirdName])
	}
}

extension UserDefaults {
	fileprivate func reset() {
		for key in dictionaryRepresentation().keys {
			removeObject(forKey: key)
		}
	}
}
