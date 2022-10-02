//
//  Created by Kai Engelhardt on 18.04.18
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

extension URLSession {
	public enum TaskError: Error {
		case generic(Error, URLResponse?)
	}

	public typealias DataTaskResult = Result<(Data, URLResponse), TaskError>
	public typealias DataTaskCompletionHandler = (DataTaskResult) -> Void

	/// Based on this [blog post](https://oleb.net/blog/2018/03/making-illegal-states-unrepresentable/) by Ole Begemann.
	public func dataTask(with url: URL, completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionDataTask {
		let task = dataTask(with: url) { data, response, error in
			if
				let data,
				let response
			{
				completionHandler(.success((data, response)))
			} else if let error {
				completionHandler(.failure(.generic(error, response)))
			} else {
				fatalError("Unexpected state in data task completion handler!")
			}
		}
		return task
	}

	public typealias DownloadTaskResult = Result<(URL, URLResponse), TaskError>
	public typealias DownloadTaskCompletionHandler = (DownloadTaskResult) -> Void

	/// Based on this [blog post](https://oleb.net/blog/2018/03/making-illegal-states-unrepresentable/) by Ole Begemann.
	public func downloadTask(
		with url: URL,
		completionHandler: @escaping DownloadTaskCompletionHandler
	) -> URLSessionDownloadTask {
		let task = downloadTask(with: url) { url, response, error in
			if
				let url,
				let response
			{
				completionHandler(.success((url, response)))
			} else if let error {
				completionHandler(.failure(.generic(error, response)))
			} else {
				fatalError("Unexpected state in download task completion handler!")
			}
		}
		return task
	}
}
