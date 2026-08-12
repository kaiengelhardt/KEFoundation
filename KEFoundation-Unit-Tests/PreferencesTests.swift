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

import Observation
@testable import KEFoundation
import XCTest

nonisolated(unsafe) private let testDefaults = UserDefaults()

private let firstNameKey = "name"
private let defaultFirstName = "Kai"

private let ageKey = "age"
private let defaultAge = 29

private let middleNameKey = "middleName"

private let jobTitleKey = "jobTitle"
private let defaultJobTitle = "Janitor"

private let stringKey = "string"
private let defaultString = "default"

private let boolKey = "bool"
private let defaultBool = false

private let intKey = "int"
private let defaultInt = 42

private let floatKey = "float"
private let defaultFloat: Float = 42.0

private let doubleKey = "double"
private let defaultDouble = 69.0

private let cgFloatKey = "cgFloat"
private let defaultCGFloat = 69.0

private let dateKey = "date"
private let defaultDate = Date(timeIntervalSince1970: 69)

private let urlKey = "url"
private let defaultURL = URL(string: "https://google.com")!

private let dataKey = "data"
private let defaultData = "42".data(using: .utf8)!

private let uuidKey = "uuid"
private let defaultUUID = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!

enum RawRepresentableExample: String, RawRepresentable, UserDefaultValue {
	case one
	case two
	case three
}

private let rawRepresentableStringRawValueKey = "rawRepresentableStringRawValue"
private let defaultRawRepresentableStringRawValue: RawRepresentableExample = .one

// DON'T FORGET ABOUT TransformableUserDefault

@available(iOS 26.0, macOS 26.0, macCatalyst 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *)
final class TestPreferences: Preferences, @unchecked Sendable {
	typealias UserDefault<Value: UserDefaultValue> = KEFoundation.UserDefault<Value, TestPreferences>

	static let `default` = TestPreferences()

	var userDefaults: UserDefaults

	init(userDefaults: UserDefaults = testDefaults) {
		self.userDefaults = userDefaults
	}

	@UserDefault(firstNameKey) var firstName = defaultFirstName
	@UserDefault(ageKey) var age = defaultAge
	@UserDefault(middleNameKey) var middleName: String?
	@UserDefault(jobTitleKey) var jobTitle: String? = defaultJobTitle

	@UserDefault(stringKey) var string = defaultString
	@UserDefault(boolKey) var bool = defaultBool
	@UserDefault(intKey) var int = defaultInt
	@UserDefault(floatKey) var float = defaultFloat
	@UserDefault(doubleKey) var double = defaultDouble
	@UserDefault(cgFloatKey) var cgFloat = defaultCGFloat
	@UserDefault(dateKey) var date = defaultDate
	@UserDefault(urlKey) var url = defaultURL
	@UserDefault(uuidKey) var uuid = defaultUUID
	@UserDefault(rawRepresentableStringRawValueKey)
	var rawRepresentableStringRawValue = defaultRawRepresentableStringRawValue
}

@available(iOS 26.0, macOS 26.0, macCatalyst 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *)
typealias Preference<Value: Sendable> = KEFoundation.Preference<Value, TestPreferences>

@available(iOS 26.0, macOS 26.0, macCatalyst 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *)
final class Object: @unchecked Sendable {
	@Preference(\.firstName) var firstName
	@Preference(\.age) var age
	@Preference(\.middleName) var middleName
	@Preference(\.jobTitle) var jobTitle

	@Preference(\.string) var string
	@Preference(\.bool) var bool
	@Preference(\.int) var int
	@Preference(\.float) var float
	@Preference(\.double) var double
	@Preference(\.cgFloat) var cgFloat
	@Preference(\.date) var date
	@Preference(\.url) var url
	@Preference(\.uuid) var uuid
	@Preference(\.rawRepresentableStringRawValue) var rawRepresentableStringRawValue
}

@available(iOS 26.0, macOS 26.0, macCatalyst 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *)
class PreferencesTests: XCTestCase {
	override func setUpWithError() throws {
		try super.setUpWithError()
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

	func testObservationsProvidesInitialAndSubsequentValues() async {
		let object = Object()
		var iterator = Observations {
			object.firstName
		}.makeAsyncIterator()

		let initialName = await iterator.next()
		XCTAssertEqual(initialName, defaultFirstName)

		let secondName = "Ralph"
		object.firstName = secondName
		let observedSecondName = await iterator.next()
		XCTAssertEqual(observedSecondName, secondName)

		let thirdName = "Lennart"
		object.firstName = thirdName
		let observedThirdName = await iterator.next()
		XCTAssertEqual(observedThirdName, thirdName)
	}

	func testObservationIsSynchronizedAcrossDeclarations() async {
		let object1 = Object()
		let object2 = Object()
		var iterator = Observations {
			object2.firstName
		}.makeAsyncIterator()

		let initialName = await iterator.next()
		XCTAssertEqual(initialName, defaultFirstName)

		let newName = "Sarah"
		object1.firstName = newName
		let observedName = await iterator.next()
		XCTAssertEqual(observedName, newName)
	}

	func testProjectedValueIsBinding() {
		let object = Object()
		let binding = object.$firstName

		XCTAssertEqual(binding.wrappedValue, defaultFirstName)
		binding.wrappedValue = "Sarah"
		XCTAssertEqual(object.firstName, "Sarah")
	}

	func testPreferencesCanBeAccessedFromDetachedTask() async {
		let preferences = TestPreferences.default
		let name = await Task.detached {
			preferences.firstName = "Sarah"
			return preferences.firstName
		}.value

		XCTAssertEqual(name, "Sarah")
	}

	func testUserDefaultValueTypes() {
		let object = Object()

		object.string = "new"
		XCTAssertEqual(object.string, testDefaults.string(forKey: stringKey))

		object.bool = true
		XCTAssertEqual(object.bool, testDefaults.bool(forKey: boolKey))

		object.int = 19
		XCTAssertEqual(object.int, testDefaults.integer(forKey: intKey))

		object.float = 420.69
		XCTAssertEqual(object.float, testDefaults.float(forKey: floatKey))

		object.double = 420.69
		XCTAssertEqual(object.double, testDefaults.double(forKey: doubleKey))

		object.cgFloat = 420.69
		XCTAssertEqual(object.cgFloat, testDefaults.double(forKey: cgFloatKey))

		object.date = Date()
		XCTAssertEqual(object.date, testDefaults.object(forKey: dateKey) as? Date)

		object.url = URL(string: "http://kaiengelhardt.com")!
		XCTAssertEqual(object.url, testDefaults.url(forKey: urlKey))

		object.uuid = UUID()
		XCTAssertEqual(object.uuid.uuidString, testDefaults.string(forKey: uuidKey))

		object.rawRepresentableStringRawValue = .two
		XCTAssertEqual(
			object.rawRepresentableStringRawValue.rawValue,
			testDefaults.string(forKey: rawRepresentableStringRawValueKey)
		)
	}
}

extension UserDefaults {
	fileprivate func reset() {
		for key in dictionaryRepresentation().keys {
			removeObject(forKey: key)
		}
	}
}
