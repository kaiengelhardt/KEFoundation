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

#if !os(watchOS)
import UIKit

public class MaskOverlayView: UIView {
	public weak var maskPath: CGPath? {
		didSet {
			updatePath()
		}
	}

	public var maskColor: UIColor? {
		didSet {
			updateColor()
		}
	}

	public override class var layerClass: AnyClass {
		CAShapeLayer.self
	}

	private var shapeLayer: CAShapeLayer {
		layer as! CAShapeLayer // swiftlint:disable:this force_cast
	}

	public init() {
		super.init(frame: .zero)
		setUpUI()
	}

	@available(*, unavailable)
	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setUpUI() {
		shapeLayer.fillRule = .evenOdd
	}

	public override func layoutSubviews() {
		super.layoutSubviews()
		updatePath()
	}

	public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		if #available(iOS 13, *) {
			if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
				updateColor()
			}
		}
	}

	private func updatePath() {
		if let maskPath {
			let path = CGMutablePath()
			path.addPath(UIBezierPath(rect: bounds).cgPath)
			path.addPath(maskPath)
			shapeLayer.path = path
		} else {
			shapeLayer.path = nil
		}
	}

	private func updateColor() {
		shapeLayer.fillColor = maskColor?.cgColor
	}
}
#endif
