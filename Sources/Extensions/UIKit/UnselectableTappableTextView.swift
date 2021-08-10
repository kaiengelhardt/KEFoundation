//
//  Created by Kai Engelhardt on 08.02.20.
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

/// Taken from this [StackOverFlow question](https://stackoverflow.com/questions/36198299/uitextview-disable-selection-allow-links).
public class UnselectableTappableTextView: UITextView {

	public override var selectedTextRange: UITextRange? {
		get {
			nil
		}
		set {} // swiftlint:disable:this unused_setter_value
	}

	public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		if gestureRecognizer is UIPanGestureRecognizer {
			// required for compatibility with isScrollEnabled
			return super.gestureRecognizerShouldBegin(gestureRecognizer)
		}
		if
			let tapGestureRecognizer = gestureRecognizer as? UITapGestureRecognizer,
			tapGestureRecognizer.numberOfTapsRequired == 1
		{
			// required for compatibility with links
			return super.gestureRecognizerShouldBegin(gestureRecognizer)
		}
		// allowing smallDelayRecognizer for links
		// https://stackoverflow.com/questions/46143868/xcode-9-uitextview-links-no-longer-clickable

		// comparison value is used to distinguish between 0.12 (smallDelayRecognizer)
		// and 0.5 (textSelectionForce and textLoupe)
		if
			let longPressGestureRecognizer = gestureRecognizer as? UILongPressGestureRecognizer,
			longPressGestureRecognizer.minimumPressDuration < 0.325
		{
			return super.gestureRecognizerShouldBegin(gestureRecognizer)
		}
		// preventing selection from loupe/magnifier (_UITextSelectionForceGesture), multi tap, tap and a half, etc.
		gestureRecognizer.isEnabled = false
		return false
	}
}
