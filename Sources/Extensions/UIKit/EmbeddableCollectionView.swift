//
//  Created by Kai Engelhardt on 21.01.20.
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

open class EmbeddableCollectionView: UICollectionView {
	
	public override var contentSize: CGSize {
		didSet {
			invalidateIntrinsicContentSize()
		}
	}
	
	public override var contentInset: UIEdgeInsets {
		didSet {
			invalidateIntrinsicContentSize()
		}
	}
	
	public override var intrinsicContentSize: CGSize {
		let contentSize = collectionViewLayout.collectionViewContentSize
		return CGSize(width: contentSize.width + contentInset.left + contentInset.right, height: contentSize.height + contentInset.top + contentInset.bottom)
	}
	
	public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
		super.init(frame: frame, collectionViewLayout: layout)
		setUp()
	}
	
	@available(*, unavailable)
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setUp()
	}
	
	private func setUp() {
		isScrollEnabled = false
	}
}
