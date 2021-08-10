//
//  Created by Kai Engelhardt on 11.12.19.
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

public class SeparatorView: UIView {

	private let contentView = UIView()

	public var axis: NSLayoutConstraint.Axis = .horizontal {
		didSet {
			updateInsets()
			invalidateIntrinsicContentSize()
		}
	}

	public var thickness: CGFloat = 1 {
		didSet {
			invalidateIntrinsicContentSize()
		}
	}

	public var isRounded = false {
		didSet {
			updateCornerRadius()
		}
	}

	public var separatorColor: UIColor? {
		get {
			contentView.backgroundColor
		}
		set {
			contentView.backgroundColor = newValue
		}
	}

	public var edgeInsets: NSDirectionalEdgeInsets = .zero {
		didSet {
			updateInsets()
		}
	}

	public override var intrinsicContentSize: CGSize {
		switch axis {
		case .horizontal:
			return CGSize(width: edgeInsets.leading + edgeInsets.trailing, height: thickness)
		case .vertical:
			return CGSize(width: thickness, height: edgeInsets.top + edgeInsets.bottom)
		@unknown default:
			return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
		}
	}

	public override init(frame: CGRect = .zero) {
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

		preservesSuperviewLayoutMargins = false

		contentView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(contentView)
		constraints += contentView.constraintsMatchingEdges(of: layoutMarginsGuide)
		contentView.backgroundColor = .separator
	}

	private func updateInsets() {
		switch axis {
		case .horizontal:
			directionalLayoutMargins = NSDirectionalEdgeInsets(
				top: 0,
				leading: edgeInsets.leading,
				bottom: 0,
				trailing: edgeInsets.trailing
			)
		case .vertical:
			directionalLayoutMargins = NSDirectionalEdgeInsets(
				top: edgeInsets.top,
				leading: 0,
				bottom: edgeInsets.bottom,
				trailing: 0
			)
		@unknown default:
			break
		}
	}

	private func updateCornerRadius() {
		if isRounded {
			contentView.makePillShaped()
		} else {
			contentView.layer.cornerRadius = 0
		}
	}

	public override func layoutSubviews() {
		super.layoutSubviews()
		updateCornerRadius()
	}
}
