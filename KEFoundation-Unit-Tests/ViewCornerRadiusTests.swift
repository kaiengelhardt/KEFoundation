//
//  Created by Kai Engelhardt on 25.12.22
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

#if canImport(UIKit) && !os(watchOS)
@testable import KEFoundation
import UIKit
import XCTest

final class ViewCornerRadiusTests: XCTestCase {
	func testApplyFullViewCornerRadiusOnView() {
		let view = UIView()
		view.frame = CGRect(x: 20, y: 20, width: 200, height: 100)
		ViewCornerRadius.full.apply(to: view)
		XCTAssertEqual(view.layer.cornerRadius, 50)

		view.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
		ViewCornerRadius.full.apply(to: view)
		XCTAssertEqual(view.layer.cornerRadius, 5)

		view.frame = .zero
		ViewCornerRadius.full.apply(to: view)
		XCTAssertEqual(view.layer.cornerRadius, 0)
	}

	func testApplyFractionalCornerRadiusOnView() {
		let view = UIView()
		view.frame = CGRect(x: 20, y: 20, width: 200, height: 100)
		ViewCornerRadius.fraction(0.3).apply(to: view)
		XCTAssertEqual(view.layer.cornerRadius, 15)

		view.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
		ViewCornerRadius.fraction(0.25).apply(to: view)
		XCTAssertEqual(view.layer.cornerRadius, 1.25)

		view.frame = .zero
		ViewCornerRadius.fraction(0.9).apply(to: view)
		XCTAssertEqual(view.layer.cornerRadius, 0)
	}

	func testApplyFixedCornerRadiusOnView() {
		let view = UIView()
		view.frame = CGRect(x: 20, y: 20, width: 200, height: 100)
		ViewCornerRadius.fixed(30).apply(to: view)
		XCTAssertEqual(view.layer.cornerRadius, 30)

		view.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
		ViewCornerRadius.fixed(30).apply(to: view)
		XCTAssertEqual(view.layer.cornerRadius, 30)

		view.frame = .zero
		ViewCornerRadius.fixed(30).apply(to: view)
		XCTAssertEqual(view.layer.cornerRadius, 30)
	}

	func testApplyZeroCornerRadiusOnView() {
		let view = UIView()
		view.frame = CGRect(x: 20, y: 20, width: 200, height: 100)
		ViewCornerRadius.zero.apply(to: view)
		XCTAssertEqual(view.layer.cornerRadius, 0)

		view.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
		ViewCornerRadius.zero.apply(to: view)
		XCTAssertEqual(view.layer.cornerRadius, 0)

		view.frame = .zero
		ViewCornerRadius.zero.apply(to: view)
		XCTAssertEqual(view.layer.cornerRadius, 0)
	}

	func testApplyCornerRadiusOnLayer() {
		let layer = CALayer()
		layer.frame = CGRect(x: 20, y: 20, width: 200, height: 100)
		ViewCornerRadius.full.apply(to: layer)
		XCTAssertEqual(layer.cornerRadius, 50)

		ViewCornerRadius.fraction(0.3).apply(to: layer)
		XCTAssertEqual(layer.cornerRadius, 15)

		ViewCornerRadius.fixed(30).apply(to: layer)
		XCTAssertEqual(layer.cornerRadius, 30)

		ViewCornerRadius.zero.apply(to: layer)
		XCTAssertEqual(layer.cornerRadius, 0)
	}
}
#endif
