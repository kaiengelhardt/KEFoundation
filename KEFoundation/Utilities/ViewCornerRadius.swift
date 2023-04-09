// Created by Kai Engelhardt on 27.09.22.

#if !os(watchOS)
import UIKit

public enum ViewCornerRadius {
	public static let full: ViewCornerRadius = .fraction(1)
	public static let zero: ViewCornerRadius = .fraction(0)

	case fraction(Double)
	case fixed(Double)

	public func apply(to layer: CALayer) {
		switch self {
		case let .fraction(fraction):
			layer.cornerRadius = layer.bounds.smallestSide / 2 * fraction
		case let .fixed(radius):
			layer.cornerRadius = radius
		}
	}

	public func apply(to view: UIView) {
		apply(to: view.layer)
	}
}
#endif
