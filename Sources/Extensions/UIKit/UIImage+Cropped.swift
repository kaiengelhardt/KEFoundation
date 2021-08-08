//
//  Created by Kai Engelhardt on 27.05.20.
//  Copyright © 2020 Kai Engelhardt. All rights reserved.
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

import UIKit

extension UIImage {
	
	public func cropped(to rect: CGRect) -> UIImage? {
		func rad(_ deg: CGFloat) -> CGFloat {
			return CGFloat(deg / 180.0 * .pi)
		}
		
		var rectTransform: CGAffineTransform
		switch imageOrientation {
		case .left:
			let rotation = CGAffineTransform(rotationAngle: rad(90))
			rectTransform = rotation.translatedBy(x: 0, y: -size.height)
		case .right:
			let rotation = CGAffineTransform(rotationAngle: rad(-90))
			rectTransform = rotation.translatedBy(x: -size.width, y: 0)
		case .down:
			let rotation = CGAffineTransform(rotationAngle: rad(-180))
			rectTransform = rotation.translatedBy(x: -size.width, y: -size.height)
		default:
			rectTransform = .identity
		}
		rectTransform = rectTransform.scaledBy(x: scale, y: scale)
		var transformedRect = rect.applying(rectTransform)
		transformedRect.origin.x = max(floor(transformedRect.origin.x), 0)
		transformedRect.origin.y = max(floor(transformedRect.origin.y), 0)
		transformedRect.size = CGSize(allDimensions: floor(transformedRect.size.smallestDimension))
		let imageRef = cgImage?.cropping(to: transformedRect)
		if let imageRef = imageRef {
			let result = UIImage(cgImage: imageRef, scale: scale, orientation: imageOrientation)
			return result
		} else {
			return nil
		}
	}
	
}
