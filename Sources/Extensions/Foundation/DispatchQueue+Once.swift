//
//  Created by Kai Engelhardt on 24.11.19
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

import Foundation

extension DispatchQueue {
	
	private static var onceTokens: Set<String> = []
	
	/**
	Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
	only execute the code once even in the presence of multithreaded calls.
	Based on this [Stackoverflow question](https://stackoverflow.com/questions/37886994/dispatch-once-after-the-swift-3-gcd-api-changes).
	
	- parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
	- parameter block: Block to execute once
	*/
    public class func once(token: String, closure: () -> Void) {
		objc_sync_enter(self)
		defer {
			objc_sync_exit(self)
		}
		
		guard !onceTokens.contains(token) else {
			return
		}
		
		onceTokens.insert(token)
		closure()
	}
	
	/**
	Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
	only execute the code once even in the presence of multithreaded calls.
	Based on this [Stackoverflow question](https://stackoverflow.com/questions/37886994/dispatch-once-after-the-swift-3-gcd-api-changes).
	
	- parameter block: Block to execute once
	*/
    public class func once(file: String = #file, function: String = #function, line: Int = #line, closure: () -> Void) {
		let token = "\(file):\(function):\(line)"
		once(token: token, closure: closure)
	}
}
