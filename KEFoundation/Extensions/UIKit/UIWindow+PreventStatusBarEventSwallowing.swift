//
//  Created by Kai Engelhardt on 16.07.20.
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

#if !os(watchOS)
import UIKit

extension UIWindow {
	/// Sets the window frame to be almost fullscreen, but not entirely fullscreen.
	/// This prevents a bug where the status bar properties and some other UIKit
	/// mechanics don't work properly within the app window.
	/// This is because UIKit chooses the frontmost, fullscreen window to determine the status bar style.
	@available(xrOS, unavailable)
	public func setFrameToBeNotEntirelyFullscreenToPreventThisWindowFromSwallowingStatusBarEvents(
		in screen: UIScreen = .main
	) {
		var screenBounds = screen.bounds
		screenBounds.size.height -= 1
		frame = screenBounds
	}
}
#endif
