//
//  Created by Kai Engelhardt on 28.11.19.
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

#if DEBUG

import UIKit
import SwiftUI

extension UIViewController {

	public var liveView: some View {
		LiveViewController(viewController: self)
	}

	public struct LiveViewController<VC: UIViewController>: UIViewControllerRepresentable {

		let viewController: VC

		public func makeUIViewController(context: UIViewControllerRepresentableContext<LiveViewController<VC>>) -> VC {
			return viewController
		}

		public func updateUIViewController(
			_ uiViewController: VC,
			context: UIViewControllerRepresentableContext<UIViewController.LiveViewController<VC>>
		) {}
	}
}

#endif
