// Created by Kai Engelhardt on 27.09.22.

import UIKit

public enum ViewCornerRadius {

	public static let full: ViewCornerRadius = .fraction(1)
	public static let zero: ViewCornerRadius = .fraction(0)

	case fraction(CGFloat)
	case fixed(CGFloat)

	public func apply(to layer: CALayer) {
		switch self {
		case .fraction(let fraction):
			layer.cornerRadius = layer.bounds.smallestSide / 2 * fraction
		case .fixed(let radius):
			layer.cornerRadius = radius
		}
	}

	public func apply(to view: UIView) {
		apply(to: view.layer)
	}
}
