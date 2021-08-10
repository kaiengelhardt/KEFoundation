//
//  Created by Kai Engelhardt on 16.10.17
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

import Foundation

extension Array {
	
	/**
	 Shuffles the collection in place. The item at `index` will be first in the array.
	 
	 - Parameter index: The position of the item which should be first in the resulting array.
	 */
	public mutating func shuffleBeginningWithItem(at index: Int) {
		self = shuffledBeginningWithItem(at: index)
	}
	
	/**
	 Returns the elements of the sequence, shuffled. The item at `index` will be first in the returned array.
	 
	 - Parameter index: The position of the item which should be first in the resulting array.
	 - Returns: A shuffled array of this sequence’s elements.
	 */
	public func shuffledBeginningWithItem(at index: Int) -> [Element] {
		var array = self
		let item = array.remove(at: index)
		var shuffledArray = array.shuffled()
		shuffledArray.insert(item, at: 0)
		return shuffledArray
	}
}
