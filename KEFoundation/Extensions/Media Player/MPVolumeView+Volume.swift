//
//  Created by Kai Engelhardt on 04.08.20.
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

import Foundation
import MediaPlayer

extension MPVolumeView {
	/// Based on this [StackOverFlow question](https://stackoverflow.com/questions/33168497/ios-9-how-to-change-volume-programmatically-without-showing-system-sound-bar-po/50740234).
	public var volume: Float {
		return volumeSlider?.value ?? 0
	}

	private var volumeSlider: UISlider? {
		subviews.first(where: { $0 is UISlider }) as? UISlider
	}

	/// Based on this [StackOverFlow question](https://stackoverflow.com/questions/33168497/ios-9-how-to-change-volume-programmatically-without-showing-system-sound-bar-po/50740234).
	public func setVolume(_ volume: Float) {
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
			self.volumeSlider?.value = volume
		}
	}
}
