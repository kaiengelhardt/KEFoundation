//
//  Created by Kai Engelhardt on 06.09.18
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

public class StackViewController: UIViewController {

	public private(set) var arrangedChildViewControllers: [UIViewController]

	public let scrollView: UIScrollView
	public let stackView: UIStackView
	private let widthConstraint: NSLayoutConstraint
	private let heightConstraint: NSLayoutConstraint

	private let allowsScrolling: Bool

	public var axis: NSLayoutConstraint.Axis {
		get {
			stackView.axis
		}
		set {
			stackView.axis = newValue
			updateViewConstraints()
		}
	}

	public var alignment: UIStackView.Alignment {
		get {
			stackView.alignment
		}
		set {
			stackView.alignment = newValue
		}
	}

	public var distribution: UIStackView.Distribution {
		get {
			stackView.distribution
		}
		set {
			stackView.distribution = newValue
		}
	}

	public var isBaselineRelativeArrangement: Bool {
		get {
			stackView.isBaselineRelativeArrangement
		}
		set {
			stackView.isBaselineRelativeArrangement = newValue
		}
	}

	public var isLayoutMarginsRelativeArrangement: Bool {
		get {
			stackView.isBaselineRelativeArrangement
		}
		set {
			stackView.isBaselineRelativeArrangement = newValue
		}
	}

	public var spacing: CGFloat {
		get {
			stackView.spacing
		}
		set {
			stackView.spacing = newValue
		}
	}

	// MARK: - Init

	public init(allowsScrolling: Bool = true, scrollView: UIScrollView? = nil) {
		self.allowsScrolling = allowsScrolling
		arrangedChildViewControllers = []
		let scrollView = scrollView ?? UIScrollView()
		self.scrollView = scrollView
		let stackView = UIStackView()
		self.stackView = stackView

		widthConstraint = stackView.widthAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.widthAnchor)
		heightConstraint = stackView.heightAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.heightAnchor)

		super.init(nibName: nil, bundle: nil)

		setUpUI()
	}

	@available(*, unavailable)
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setUpUI() {
		if allowsScrolling {
			view = scrollView
			stackView.translatesAutoresizingMaskIntoConstraints = false
			scrollView.addSubview(stackView)
			NSLayoutConstraint.activate(stackView.constraintsMatchingEdges(of: scrollView.contentLayoutGuide))
			scrollView.preservesSuperviewLayoutMargins = true
		} else {
			view = stackView
		}
		stackView.preservesSuperviewLayoutMargins = true
	}

	// MARK: - UIViewController

	public override func updateViewConstraints() {
		super.updateViewConstraints()
		if allowsScrolling {
			switch axis {
			case .horizontal:
				widthConstraint.isActive = false
				heightConstraint.isActive = true
			case .vertical:
				heightConstraint.isActive = false
				widthConstraint.isActive = true
			@unknown default:
				break
			}
		}
	}

	// MARK: - Public Methods

	public func addArrangedChildViewController(_ viewController: UIViewController) {
		insertArrangedChildViewController(viewController, at: arrangedChildViewControllers.count)
	}

	public func insertArrangedChildViewController(_ viewController: UIViewController, at index: Int) {
		guard !arrangedChildViewControllers.contains(viewController) else {
			return
		}

		arrangedChildViewControllers.insert(viewController, at: index)
		addChild(viewController)
		view.addSubview(viewController.view)
		viewController.didMove(toParent: self)
		stackView.insertArrangedSubview(viewController.view, at: index)
		viewController.didMove(toParent: self)
	}

	public func removeArrangedChildViewController(_ viewController: UIViewController) {
		guard let index = arrangedChildViewControllers.firstIndex(of: viewController) else {
			return
		}

		viewController.willMove(toParent: nil)
		stackView.removeArrangedSubview(viewController.view)
		viewController.view.removeFromSuperview()
		viewController.removeFromParent()
		arrangedChildViewControllers.remove(at: index)
	}

	public func customSpacing(after viewController: UIViewController) -> CGFloat {
		return stackView.customSpacing(after: viewController.view)
	}

	public func setCustomSpacing(_ spacing: CGFloat, after viewController: UIViewController) {
		stackView.setCustomSpacing(spacing, after: viewController.view)
	}
}
