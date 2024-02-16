//
//  Created by Kai Engelhardt on 09.08.19.
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

#if !os(watchOS)
import UIKit

public class CircularProgressView: UIView {
	public var progressColor: UIColor? {
		didSet {
			updateColors()
		}
	}

	public var borderColor: UIColor? {
		didSet {
			updateColors()
		}
	}

	public override var tintColor: UIColor! {
		didSet {
			updateColors()
		}
	}

	public override class var layerClass: AnyClass {
		CAShapeLayer.self
	}

	private var borderLayer: CAShapeLayer {
		layer as! CAShapeLayer
	}

	private let progressLayer = CAShapeLayer()

	private var _progress: Double = 0
	public var progress: Double {
		get {
			_progress
		}
		set {
			_progress = newValue.clamped(to: 0 ... 1)
			update()
		}
	}

	public var lineWidth: Double = 4 {
		didSet {
			borderLayer.lineWidth = lineWidth
			progressLayer.lineWidth = lineWidth
		}
	}

	public init() {
		super.init(frame: .zero)
		setUpUI()
		update()
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setUpUI() {
		borderLayer.removeAllAnimations()
		borderLayer.fillColor = nil
		borderLayer.lineWidth = lineWidth

		borderLayer.addSublayer(progressLayer)
		progressLayer.fillColor = nil
		progressLayer.lineWidth = lineWidth

		updateColors()

		if
			#available(iOS 17, *),
			#available(tvOS 17, *)
		{
			registerForTraitChanges([UITraitActiveAppearance.self]) { (self: Self, previousTraitCollection) in
				self.updateColors()
			}
		}
	}

	public func setProgress(_ progress: Double, animated: Bool) {
		UIView.animate(withDuration: 0.25) {
			self.progress = progress
		}
	}

	private func update() {
		progressLayer.strokeEnd = Double(progress)
	}

	private func updateColors() {
		borderLayer.strokeColor = borderColor?.cgColor ?? tintColor.cgColor
		progressLayer.strokeColor = progressColor?.cgColor ?? tintColor.cgColor
	}

	#if !os(visionOS)
	public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		if
			#unavailable(iOS 17),
			#unavailable(tvOS 17)
		{
			if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
				updateColors()
			}
		}
	}
	#endif

	public override func layoutSubviews() {
		super.layoutSubviews()
		borderLayer.path = circularPath(for: borderLayer)
		progressLayer.frame = borderLayer.bounds
		progressLayer.path = circularPath(for: progressLayer)
	}

	private func circularPath(for layer: CAShapeLayer) -> CGPath {
		let bezierPath = UIBezierPath(
			arcCenter: bounds.center,
			radius: (layer.bounds.smallestSide - layer.lineWidth) / 2,
			startAngle: .pi / 2 * 3,
			endAngle: .pi / 2 * 3 + .pi * 2,
			clockwise: true
		)
		return bezierPath.cgPath
	}
}
#endif
