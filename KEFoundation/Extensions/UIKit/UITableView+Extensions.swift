//
//  Created by Kai Engelhardt on 23.10.17
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

// MARK: - UITableView.StaticSection

extension UITableView {
	public struct StaticSection: Equatable {
		public var identifier = UUID()
		public var headerTitle: String?
		public var footerTitle: String?
		public var cells: [UITableViewCell]

		public init(cells: [UITableViewCell], headerTitle: String? = nil, footerTitle: String? = nil) {
			self.cells = cells
			self.headerTitle = headerTitle
			self.footerTitle = footerTitle
		}
	}
}

extension [UITableView.StaticSection] {
	public subscript(indexPath: IndexPath) -> UITableViewCell {
		return self[indexPath.section].cells[indexPath.row]
	}
}

extension UITableView {
	public func deselectCurrentlySelectRow(with transitionCoordinator: UIViewControllerTransitionCoordinator?) {
		let indexPath = indexPathForSelectedRow
		if let indexPath {
			deselectRow(at: indexPath, animated: true)
			transitionCoordinator?.notifyWhenInteractionChanges { [weak self] context in
				if context.isCancelled {
					self?.selectRow(at: indexPath, animated: false, scrollPosition: .none)
				}
			}
		}
	}
}
#endif
