//
//  Created by Kai Engelhardt on 27.11.19.
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

import UIKit

public class PageViewController: UIViewController {

	public var embeddedViewControllers: [UIViewController] = [] {
		didSet {
			remove(oldViewControllers: oldValue)
			updateEmbeddedViewControllers()
		}
	}

	public let scrollView = UIScrollView()
	public let pageControl: UIPageControl

	private let stackView = UIStackView()

	private var currentPage: Int {
		let horizontalContentOffset = scrollView.contentOffset.x
		let width = scrollView.bounds.width
		let currentPage: Int
		if width > 0 {
			currentPage = Int((horizontalContentOffset + 0.5 * width) / width)
		} else {
			currentPage = 0
		}
		return currentPage
	}

	public init(pageControl: UIPageControl) {
		self.pageControl = pageControl
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

		view.addSubview(scrollView)
		constraints += [
			scrollView.topAnchor.constraint(equalTo: view.topAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
		]
        scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.isPagingEnabled = true
		scrollView.delegate = self
		scrollView.showsHorizontalScrollIndicator = false
		pageControl.numberOfPages = 0

		scrollView.addSubview(stackView)
		constraints += stackView.constraintsMatchingEdges(of: scrollView.contentLayoutGuide)
		constraints += [
			stackView.topAnchor.constraint(equalTo: view.topAnchor),
			stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
		]
        stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.distribution = .fillEqually
		stackView.spacing = 0

		pageControl.hidesForSinglePage = true
	}

	private func updateEmbeddedViewControllers() {
		for viewController in embeddedViewControllers {
			stackView.addArrangedSubview(viewController.view)
			viewController.didMove(toParent: self)
		}
		if let firstViewController = embeddedViewControllers.first {
			NSLayoutConstraint.activate([
                firstViewController.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
			])
		}
		scrollView.contentOffset = .zero
		pageControl.numberOfPages = embeddedViewControllers.count
		pageControl.currentPage = 0
	}

	private func remove(oldViewControllers: [UIViewController]) {
		for viewController in oldViewControllers {
			viewController.view.removeFromSuperview()
			viewController.removeFromParent()
		}
	}

	private func fixContentOffset() {
		let width = scrollView.bounds.width
		scrollView.contentOffset.x = CGFloat(currentPage) * width
	}

	public override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		fixContentOffset()
	}
}

// MARK: - UIScrollViewDelegate

extension PageViewController: UIScrollViewDelegate {

	public func scrollViewDidScroll(_ scrollView: UIScrollView) {
		pageControl.currentPage = currentPage
	}
}
