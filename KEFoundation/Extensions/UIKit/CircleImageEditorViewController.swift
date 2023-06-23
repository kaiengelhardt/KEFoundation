//
//  Created by Kai Engelhardt on 26.05.20.
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

@available(tvOS, unavailable)
public protocol CircleImageEditorViewControllerDelegate: AnyObject {
	func circleImageEditorViewController(_ viewController: CircleImageEditorViewController, didFinishWith image: UIImage)
	func circleImageEditorViewControllerDidCancel(_ viewController: CircleImageEditorViewController)
	func circleImageEditorViewControllerDidFail(_ viewController: CircleImageEditorViewController)
}

@available(tvOS, unavailable)
public class CircleImageEditorViewController: UIViewController {
	public weak var delegate: CircleImageEditorViewControllerDelegate?

	private let imageView = UIImageView()
	private let scrollView = UIScrollView()
	private let overlayView = OverlayView()
	private let circleViewLayoutGuide = UILayoutGuide()
	private let circleView = CircleMaskView()

	private let bottomToolbar = UIToolbar()

	public var image: UIImage {
		didSet {
			imageView.image = image
			resetScrollViewZoom()
		}
	}

	public init(image: UIImage) {
		self.image = image
		super.init(nibName: nil, bundle: nil)
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

		view.backgroundColor = .black

		view.addSubview(scrollView)
		constraints += [
			scrollView.topAnchor.constraint(equalTo: view.topAnchor),
			scrollView.bottomAnchor.constraint(equalTo: bottomToolbar.bottomAnchor),
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
		]
		scrollView.translatesAutoresizingMaskIntoConstraints = false

		scrollView.addSubview(imageView)
		constraints += imageView.constraintsMatchingEdges(of: scrollView.contentLayoutGuide)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFit
		imageView.image = image

		scrollView.bouncesZoom = true
		scrollView.delegate = self
		scrollView.contentInsetAdjustmentBehavior = .never
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.showsVerticalScrollIndicator = false

		view.addSubview(overlayView)
		constraints += overlayView.constraintsMatchingEdges(of: scrollView)
		overlayView.translatesAutoresizingMaskIntoConstraints = false
		overlayView.backgroundColor = UIColor(white: 0, alpha: 0.5)

		view.addLayoutGuide(circleViewLayoutGuide)
		constraints += circleViewLayoutGuide.constraintsMatchingCenter(of: scrollView.layoutMarginsGuide)
		constraints += circleViewLayoutGuide.constraintsMatchingSize(of: scrollView.layoutMarginsGuide)
			.with(priority: .defaultLow)
		constraints += circleViewLayoutGuide.constraintsMatchingSize(
			of: scrollView.layoutMarginsGuide,
			relation: .lessThanOrEqual
		)
		constraints.append(circleViewLayoutGuide.aspectRatioConstraint())
		overlayView.mask = circleView

		view.addSubview(bottomToolbar)
		constraints += [
			bottomToolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			bottomToolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			bottomToolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
		]
		bottomToolbar.translatesAutoresizingMaskIntoConstraints = false
		bottomToolbar.barStyle = .black
		bottomToolbar.isTranslucent = true

		let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
		cancelButton.accessibilityIdentifier = "cancel"
		let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
		doneButton.accessibilityIdentifier = "done"
		bottomToolbar.items = [
			cancelButton,
			space,
			doneButton,
		]
	}

	public override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		resetScrollViewZoom()
	}

	public override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		// Trigger a scroll view layout update to fix a bug on iOS 12 where scrollView.contentSize is {0, 0}
		scrollView.setNeedsLayout()
		scrollView.layoutIfNeeded()

		circleView.frame = view.bounds
		circleView.circleFrame = circleViewLayoutGuide.layoutFrame

		scrollView.contentInset.left = circleViewLayoutGuide.layoutFrame.minX
		scrollView.contentInset.right = scrollView.frame.width - circleViewLayoutGuide.layoutFrame.maxX
		scrollView.contentInset.top = circleViewLayoutGuide.layoutFrame.minY
		scrollView.contentInset.bottom = scrollView.frame.height - circleViewLayoutGuide.layoutFrame.maxY

		updateZoomScaleRange()
	}

	private func resetScrollViewZoom() {
		view.setNeedsLayout()
		view.layoutIfNeeded()
		scrollView.zoomScale = scrollView.minimumZoomScale
		// Make sure crop rect is centered
		if scrollView.contentSize.width > scrollView.contentSize.height {
			scrollView.contentOffset.x = (scrollView.contentSize.width - circleViewLayoutGuide.layoutFrame.width) / 2
				- scrollView.contentInset.left
		} else {
			scrollView.contentOffset.y = (scrollView.contentSize.height - circleViewLayoutGuide.layoutFrame.height) / 2
				- scrollView.contentInset.top
		}
	}

	private func updateZoomScaleRange() {
		let currentZoomScale = scrollView.zoomScale == 0 ? 1 : scrollView.zoomScale
		if scrollView.contentSize.width > scrollView.contentSize.height {
			scrollView.minimumZoomScale = (circleViewLayoutGuide.layoutFrame.height) /
				(scrollView.contentSize.height / currentZoomScale)
		} else {
			scrollView.minimumZoomScale = (circleViewLayoutGuide.layoutFrame.width) /
				(scrollView.contentSize.width / currentZoomScale)
		}
		scrollView.maximumZoomScale = 4 * scrollView.minimumZoomScale
	}

	private func croppedImage() -> UIImage? {
		let cutoutSize = circleViewLayoutGuide.layoutFrame.size
		let xFraction = (scrollView.contentOffset.x + scrollView.contentInset.left) / scrollView.contentSize.width
		let yFraction = (scrollView.contentOffset.y + scrollView.contentInset.top) / scrollView.contentSize.height
		let x = image.size.width * xFraction
		let y = image.size.height * yFraction
		let cropOrigin = CGPoint(x: x, y: y)
		let cropSize = cutoutSize / scrollView.zoomScale
		var cropRect = CGRect(origin: cropOrigin, size: cropSize)
		cropRect = fitRect(cropRect, to: image.size)
		return image.cropped(to: cropRect)
	}

	@objc
	private func done() {
		if let image = croppedImage() {
			delegate?.circleImageEditorViewController(self, didFinishWith: image)
		} else {
			delegate?.circleImageEditorViewControllerDidFail(self)
		}
	}

	private func fitRect(_ rect: CGRect, to size: CGSize) -> CGRect {
		let maximumExtentRect = CGRect(origin: .zero, size: size)
		var fixedRect = rect
		fixedRect.origin.x = max(0, floor(fixedRect.origin.x))
		fixedRect.origin.y = max(0, floor(fixedRect.origin.y))
		// Due to rounding errors, we sometimes get a difference of one point between width and height
		fixedRect.size = CGSize(allDimensions: floor(fixedRect.size.smallestDimension))
		if maximumExtentRect.contains(fixedRect) {
			return fixedRect
		} else {
			// Handling could be better but it's just an edge case, so we just take a rect that works
			return CGRect(origin: .zero, size: CGSize(allDimensions: floor(maximumExtentRect.smallestSide)))
		}
	}

	@objc
	private func cancel() {
		delegate?.circleImageEditorViewControllerDidCancel(self)
	}
}

// MARK: UIScrollViewDelegate

@available(tvOS, unavailable)
extension CircleImageEditorViewController: UIScrollViewDelegate {
	public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return imageView
	}
}

@available(tvOS, unavailable)
extension CircleImageEditorViewController {
	class OverlayView: UIView {
		override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
			return nil
		}
	}

	class CircleMaskView: UIView {
		var circleFrame: CGRect? {
			didSet {
				updatePath()
			}
		}

		override class var layerClass: AnyClass {
			CAShapeLayer.self
		}

		var shapeLayer: CAShapeLayer {
			layer as! CAShapeLayer
		}

		init() {
			super.init(frame: .zero)
			setUpUI()
		}

		@available(*, unavailable)
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}

		private func setUpUI() {
			backgroundColor = .clear
			shapeLayer.fillColor = UIColor.black.cgColor
			shapeLayer.fillRule = .evenOdd
		}

		func updatePath() {
			if let circleFrame {
				let path = CGMutablePath()
				path.addPath(UIBezierPath(rect: bounds).cgPath)
				path.addPath(UIBezierPath(roundedRect: circleFrame, cornerRadius: circleFrame.largestSide).cgPath)
				shapeLayer.path = path
			} else {
				shapeLayer.path = nil
			}
		}

		override func layoutSubviews() {
			super.layoutSubviews()
			updatePath()
		}

		override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
			return nil
		}
	}
}
#endif
