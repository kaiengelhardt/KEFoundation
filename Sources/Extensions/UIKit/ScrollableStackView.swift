//
//  Created by Kai Engelhardt on 30.09.19
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

import UIKit

public class ScrollableStackView: UIView {
	
	public var arrangedSubviews: [UIView] {
		stackView.arrangedSubviews
	}
	
	public let scrollView: UIScrollView
	private let stackView: UIStackView
	private let widthConstraint: NSLayoutConstraint
	private let heightConstraint: NSLayoutConstraint
	private let constraintsForScrollingAllowed: [NSLayoutConstraint]
	private let constraintsForScrollingDisallowed: [NSLayoutConstraint]
	
	private var allowsScrolling: Bool {
		didSet {
			updateConstraints()
		}
	}
	
	public var axis: NSLayoutConstraint.Axis {
		get {
			stackView.axis
		}
		set {
			stackView.axis = newValue
			updateConstraints()
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
	
	public init(frame: CGRect = .zero, allowsScrolling: Bool = true) {
		self.allowsScrolling = allowsScrolling
		let stackView = UIStackView()
		self.stackView = stackView
		let scrollView = UIScrollView()
		self.scrollView = scrollView
		
		widthConstraint = stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
		heightConstraint = stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
		constraintsForScrollingAllowed = stackView.constraintsMatchingEdges(of: scrollView.contentLayoutGuide)
		constraintsForScrollingDisallowed = stackView.constraintsMatchingEdges(of: scrollView)
		
		super.init(frame: frame)
		
		setUpUI()
	}
	
	@available(*, unavailable)
	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setUpUI() {
		var constraints: [NSLayoutConstraint] = []
		defer {
			NSLayoutConstraint.activate(constraints)
		}
		addSubview(scrollView)
		constraints += scrollView.constraintsMatchingEdgesOfSuperview()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.preservesSuperviewLayoutMargins = true

		scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.preservesSuperviewLayoutMargins = true
		
		updateConstraints()
	}
	
	public override func updateConstraints() {
		super.updateConstraints()
		if allowsScrolling {
			NSLayoutConstraint.deactivate(constraintsForScrollingDisallowed)
			NSLayoutConstraint.activate(constraintsForScrollingAllowed)
		} else {
			NSLayoutConstraint.deactivate(constraintsForScrollingAllowed)
			NSLayoutConstraint.activate(constraintsForScrollingDisallowed)
		}
		
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
	
	public func addArrangedSubview(_ view: UIView) {
		stackView.addArrangedSubview(view)
	}
	
	public func removeArrangedSubview(_ view: UIView) {
		stackView.removeArrangedSubview(view)
	}
	
	public func insertArrangedSubview(_ view: UIView, at stackIndex: Int) {
		stackView.insertArrangedSubview(view, at: stackIndex)
	}
	
	public func customSpacing(after arrangedSubview: UIView) -> CGFloat {
		return stackView.customSpacing(after: arrangedSubview)
	}
	
	public func setCustomSpacing(_ spacing: CGFloat, after arrangedSubview: UIView) {
		stackView.setCustomSpacing(spacing, after: arrangedSubview)
	}
}
