//
//  Created by Kai Engelhardt on 10.01.18
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

import UIKit

open class ContainerViewController: UIViewController {

	private var _embeddedViewController: UIViewController?

	public var embeddedViewController: UIViewController? {
		get {
			_embeddedViewController
		}
		set {
			guard newValue != _embeddedViewController else {
				return
			}
			if let oldViewController = _embeddedViewController {
				embeddedViewControllerConstraints = []
                oldViewController.willMove(toParent: nil)
                oldViewController.view.removeFromSuperview()
                oldViewController.removeFromParent()
			}
			_embeddedViewController = newValue
			if let newViewController = newValue {
				newViewController.view.translatesAutoresizingMaskIntoConstraints = false
                addChild(newViewController)
                view.addSubview(newViewController.view)
                newViewController.didMove(toParent: self)
                view.sendSubviewToBack(newViewController.view)
				embeddedViewControllerConstraints = newViewController.view.constraintsMatchingEdges(
                    of: embeddedViewControllerPositioningLayoutSurface
                )
			}
			#if os(iOS)
			setNeedsStatusBarAppearanceUpdate()
			setNeedsUpdateOfHomeIndicatorAutoHidden()
			setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
			#endif
		}
	}

	private var _embeddedViewControllerPositioningLayoutSurface: LayoutSurface?

	public var embeddedViewControllerPositioningLayoutSurface: LayoutSurface? {
		get {
			_embeddedViewControllerPositioningLayoutSurface ?? view
		}
		set {
			_embeddedViewControllerPositioningLayoutSurface = newValue
			embeddedViewControllerConstraints = embeddedViewController?.view.constraintsMatchingEdges(
                of: embeddedViewControllerPositioningLayoutSurface
            ) ?? []
		}
	}

	private var embeddedViewControllerConstraints: [NSLayoutConstraint] = [] {
		didSet {
			NSLayoutConstraint.deactivate(oldValue)
			NSLayoutConstraint.activate(embeddedViewControllerConstraints)
		}
	}

	public convenience init() {
		self.init(nibName: nil, bundle: nil)
	}

	public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		view.preservesSuperviewLayoutMargins = true
	}

	@available(*, unavailable)
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	#if os(iOS)

	open override var childForStatusBarStyle: UIViewController? {
		embeddedViewController
	}

	open override var childForStatusBarHidden: UIViewController? {
		embeddedViewController
	}

	open override var childForHomeIndicatorAutoHidden: UIViewController? {
		embeddedViewController
	}

	open override var childForScreenEdgesDeferringSystemGestures: UIViewController? {
		embeddedViewController
	}

	#endif

	public func animate(to viewController: UIViewController) {
		UIView.transition(
            with: view,
            duration: 0.5,
            options: [.beginFromCurrentState, .transitionCrossDissolve],
            animations: {
                UIView.performWithoutAnimation {
                    self.embeddedViewController = viewController
                }
            }
        )
	}
}
