//
//  LayoutConstraintContainer.swift
//  KEFoundation
//
//  Created by Kai Engelhardt on 24.08.18
//  Copyright © 2018 Kai Engelhardt. All rights reserved.
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

#if canImport(UIKit)

import UIKit

#elseif canImport(AppKit)

import AppKit

#endif

public protocol LayoutConstraintContainer {
	
	var constraints: [NSLayoutConstraint] { get }
	
}

extension NSLayoutConstraint: LayoutConstraintContainer {
	
	public var constraints: [NSLayoutConstraint] {
		return [self]
	}
	
	public class func activate(_ constraintContainer: LayoutConstraintContainer) {
		self.activate(constraintContainer.constraints)
	}
	
	public class func deactivate(_ constraintContainer: LayoutConstraintContainer) {
		self.deactivate(constraintContainer.constraints)
	}
	
}

extension Array: LayoutConstraintContainer where Element: LayoutConstraintContainer {
	
	public var constraints: [NSLayoutConstraint] {
		return flatMap { $0.constraints }
	}
	
}
