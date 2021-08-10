//
//  Created by Kai Engelhardt on 05.12.19.
//  Copyright © 2019 Kai Engelhardt. All rights reserved.
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

import QuartzCore
import UIKit

public struct Shadow {
	
	public var color: CGColor?
	public var opacity: Float
	public var offset: CGSize
	public var radius: CGFloat
	public var path: CGPath?
	
	public static let noShadow = Shadow(color: nil, opacity: 0, offset: .zero, radius: 0)
	public static let `default` = Shadow(color: UIColor.black.cgColor, opacity: 0.2, offset: .zero, radius: 16)
	
	public init(color: CGColor?, opacity: Float, offset: CGSize, radius: CGFloat, path: CGPath? = nil) {
		self.color = color
		self.opacity = opacity
		self.offset = offset
		self.radius = radius
		self.path = path
	}
}

extension CALayer {
	
	public var shadow: Shadow {
		get {
			Shadow(color: shadowColor, opacity: shadowOpacity, offset: shadowOffset, radius: shadowRadius, path: shadowPath)
		}
		set {
			shadowColor = newValue.color
			shadowOpacity = newValue.opacity
			shadowOffset = newValue.offset
			shadowRadius = newValue.radius
			shadowPath = newValue.path
		}
	}
}
