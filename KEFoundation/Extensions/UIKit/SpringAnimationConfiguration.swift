//
//  Created by Kai Engelhardt on 04.07.24
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

#if !os(watchOS)
import UIKit

public struct SpringAnimationConfiguration: Sendable {
	public enum Duration: Sendable, RawRepresentable, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
		/// A duration of 0.5 seconds.
		case medium

		/// A duration of 1 second.
		case long

		/// A custom duration.
		case custom(TimeInterval)

		public var rawValue: TimeInterval {
			switch self {
			case .medium:
				return 0.5
			case .long:
				return 1
			case let .custom(timeInterval):
				return timeInterval
			}
		}

		public init(rawValue timeInterval: TimeInterval) {
			self = Self.duration(forTimeInterval: timeInterval)
		}

		public init(floatLiteral timeInterval: TimeInterval) {
			self = Self.duration(forTimeInterval: timeInterval)
		}

		public init(integerLiteral value: IntegerLiteralType) {
			self = Self.duration(forTimeInterval: TimeInterval(value))
		}

		private static func duration(forTimeInterval timeInterval: TimeInterval) -> Duration {
			switch timeInterval {
			case Duration.medium.rawValue:
				return .medium
			case Duration.long.rawValue:
				return .long
			default:
				return .custom(timeInterval)
			}
		}
	}

	public static let dampedSpring = SpringAnimationConfiguration(duration: .medium)
	public static let oscillatingSpring = SpringAnimationConfiguration(
		duration: .medium,
		springDamping: 0.7
	)

	public static let defaultDelay: TimeInterval = 0
	public static let defaultSpringDamping: CGFloat = 1
	public static let defaultInitialSpringVelocity: CGFloat = 0
	public static let defaultOptions: UIView.AnimationOptions = [
		.allowAnimatedContent,
		.allowUserInteraction,
		.beginFromCurrentState,
	]

	public var duration: Duration
	public var delay: TimeInterval
	public var springDamping: CGFloat
	public var initialSpringVelocity: CGFloat
	public var options: UIView.AnimationOptions
	fileprivate var shouldAnimate = true

	public init(
		duration: Duration,
		delay: TimeInterval = Self.defaultDelay,
		springDamping: CGFloat = Self.defaultSpringDamping,
		initialSpringVelocity: CGFloat = Self.defaultInitialSpringVelocity,
		options: UIView.AnimationOptions = Self.defaultOptions
	) {
		self.duration = duration
		self.delay = delay
		self.springDamping = springDamping
		self.initialSpringVelocity = initialSpringVelocity
		self.options = options
	}

	public func with(duration: Duration) -> Self {
		var configuration = self
		configuration.duration = duration
		return configuration
	}

	public func with(delay: TimeInterval) -> Self {
		var configuration = self
		configuration.delay = delay
		return configuration
	}

	public func with(springDamping: CGFloat) -> Self {
		var configuration = self
		configuration.springDamping = springDamping
		return configuration
	}

	public func with(initialSpringVelocity: CGFloat) -> Self {
		var configuration = self
		configuration.initialSpringVelocity = initialSpringVelocity
		return configuration
	}

	public func with(options: UIView.AnimationOptions) -> Self {
		var configuration = self
		configuration.options = options
		return configuration
	}

	public func animated(_ shouldAnimate: Bool) -> Self {
		var configuration = self
		configuration.shouldAnimate = shouldAnimate
		return configuration
	}
}

extension UIView {
	public static func animate(
		using configuration: SpringAnimationConfiguration,
		animations: @escaping () -> Void,
		completion: ((Bool) -> Void)? = nil
	) {
		guard configuration.shouldAnimate else {
			animations()
			completion?(true)
			return
		}
		UIView.animate(
			withDuration: configuration.duration.rawValue,
			delay: configuration.delay,
			usingSpringWithDamping: configuration.springDamping,
			initialSpringVelocity: configuration.initialSpringVelocity,
			options: configuration.options,
			animations: animations,
			completion: completion
		)
	}
}
#endif
