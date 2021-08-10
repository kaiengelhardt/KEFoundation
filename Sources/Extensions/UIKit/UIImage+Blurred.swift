//
//  Created by Kai Engelhardt on 11.03.20.
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
import CoreImage

extension UIImage {

	/// Returns a version of this image with a gaussian blur applied to it.
	/// Based on this StackOverFlow [question](https://stackoverflow.com/questions/41156542/how-to-blur-an-existing-image-in-a-uiimageview-with-swift/41157042#41157042).
	/// - Parameter blurRadius: Specifies how blurred the image should be.
    /// The larger the blur radius, the more blurred the resulting image becomes.
    public func blurredImage(blurRadius: CGFloat = 10) -> UIImage? {
		guard
			let currentFilter = CIFilter(name: "CIGaussianBlur"),
			let inputImage = CIImage(image: self) else
		{
			return nil
		}

		let context = CIContext(options: nil)

		currentFilter.setValue(inputImage, forKey: kCIInputImageKey)
		currentFilter.setValue(blurRadius, forKey: kCIInputRadiusKey)

		guard let cropFilter = CIFilter(name: "CICrop") else {
			return nil
		}
		cropFilter.setValue(currentFilter.outputImage, forKey: kCIInputImageKey)
		cropFilter.setValue(CIVector(cgRect: inputImage.extent), forKey: "inputRectangle")

		guard
			let outputImage = cropFilter.outputImage,
			let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else
		{
			return nil
		}

		let blurredImage = UIImage(cgImage: cgImage)
		return blurredImage
	}
}
