//
//  Created by Kai Engelhardt on 13.10.17
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

import CoreData

public class FetchedResultsUpdater: NSObject {
	public enum SectionUpdate {
		case insert(Int)
		case delete(Int)
	}

	public enum RowUpdate {
		case insert(IndexPath)
		case delete(IndexPath)
		case update(IndexPath)
		case move(IndexPath, IndexPath)
	}

	public var indexPathOffset = IndexPath(row: 0, section: 0)

	public weak var delegate: FetchedResultsUpdaterDelegate?

	private var sectionUpdates: [SectionUpdate] = []
	private var rowUpdates: [RowUpdate] = []

	private var updatesEnabled = true

	public func performWithoutUpdatesEnabled(_ closure: () -> Void) {
		updatesEnabled = false
		closure()
		updatesEnabled = true
	}
}

// MARK: NSFetchedResultsControllerDelegate

extension FetchedResultsUpdater: NSFetchedResultsControllerDelegate {
	public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		sectionUpdates = []
		rowUpdates = []
	}

	public func controller(
		_ controller: NSFetchedResultsController<NSFetchRequestResult>,
		didChange sectionInfo: NSFetchedResultsSectionInfo,
		atSectionIndex _sectionIndex: Int,
		for type: NSFetchedResultsChangeType
	) {
		let sectionIndex = _sectionIndex + indexPathOffset.section
		switch type {
		case .insert:
			sectionUpdates.append(.insert(sectionIndex))
		case .delete:
			sectionUpdates.append(.delete(sectionIndex))
		default:
			break
		}
	}

	public func controller(
		_ controller: NSFetchedResultsController<NSFetchRequestResult>,
		didChange anObject: Any,
		at _indexPath: IndexPath?,
		for type: NSFetchedResultsChangeType,
		newIndexPath _newIndexPath: IndexPath?
	) {
		let indexPath: IndexPath?
		if let _indexPath {
			indexPath = IndexPath(
				row: _indexPath.row + indexPathOffset.row,
				section: _indexPath.section + indexPathOffset.section
			)
		} else {
			indexPath = nil
		}
		let newIndexPath: IndexPath?
		if let _newIndexPath {
			newIndexPath = IndexPath(
				row: _newIndexPath.row + indexPathOffset.row,
				section: _newIndexPath.section + indexPathOffset.section
			)
		} else {
			newIndexPath = nil
		}

		switch type {
		case .insert:
			rowUpdates.append(.insert(newIndexPath!))
		case .delete:
			rowUpdates.append(.delete(indexPath!))
		case .update:
			rowUpdates.append(.update(indexPath!))
		case .move:
			rowUpdates.append(.move(indexPath!, newIndexPath!))
		@unknown default:
			break
		}
	}

	public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		guard updatesEnabled else {
			return
		}
		delegate?.updater(self, didUpdateWithSectionUpdates: sectionUpdates, rowUpdates: rowUpdates)
	}
}

public protocol FetchedResultsUpdaterDelegate: AnyObject {
	func updater(
		_ updater: FetchedResultsUpdater,
		didUpdateWithSectionUpdates sectionUpdates: [FetchedResultsUpdater.SectionUpdate],
		rowUpdates: [FetchedResultsUpdater.RowUpdate]
	)
}
