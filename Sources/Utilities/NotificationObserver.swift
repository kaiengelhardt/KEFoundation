//
//  Created by Kai Engelhardt on 31.01.18
//  Copyright © 2021 Kai Engelhardt. All rights reserved.
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

import Foundation

/// Based on this [tweet](https://twitter.com/jaredsinclair/status/951536021459619840) by Jared Sinclair.
public class NotificationObserver {

	private var observers: [NSObjectProtocol] = []
	private let notificationCenter: NotificationCenter
	private let queue: OperationQueue

	public init(notificationCenter: NotificationCenter = .default, queue: OperationQueue = .main) {
		self.notificationCenter = notificationCenter
		self.queue = queue
	}

	deinit {
		for observer in observers {
			notificationCenter.removeObserver(observer)
		}
	}

	/// Adds an entry to the notification center's dispatch table that includes a notification name
	/// and a block to add to the queue.
	/// All observers will be removed when the `NotificationObserver` is released.
	///
	/// - Parameters:
	///   - name: The notification name.
	///   - handler: The block to be executed when the notification is received.
	public func when(_ name: Notification.Name, object: Any? = nil, perform handler: @escaping (Notification) -> Void) {
		let observer = notificationCenter.addObserver(forName: name, object: object, queue: queue, using: handler)
		observers.append(observer)
	}
}
