//
//  Created by Kai Engelhardt on 21.01.18
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

public protocol Managed: NSFetchRequestResult {
	
	static var entityName: String { get }
	
	static var defaultSortDescriptors: [NSSortDescriptor] { get }
}

extension Managed where Self: NSManagedObject {
	
	public static var entityName: String {
		return entity().name!
	}
	
	public static var defaultSortDescriptors: [NSSortDescriptor] {
		return []
	}
	
	public static var sortedFetchRequest: NSFetchRequest<Self> {
		let request = self.fetchRequest() as! NSFetchRequest<Self> // swiftlint:disable:this force_cast
		request.sortDescriptors = defaultSortDescriptors
		return request
	}
	
	private static func materializedObject(in context: NSManagedObjectContext, matching predicate: NSPredicate) -> Self? {
		for object in context.registeredObjects where !object.isFault {
			guard let result = object as? Self, predicate.evaluate(with: result) else {
				continue
			}
			return result
		}
		return nil
	}
	
	public static func fetch(
		in context: NSManagedObjectContext,
		configuration: (NSFetchRequest<Self>) -> Void = { _ in }
	) -> [Self] {
		let request = NSFetchRequest<Self>(entityName: Self.entityName)
		configuration(request)
		return try! context.fetch(request) // swiftlint:disable:this force_try
	}
	
	public static func findOrFetch(in context: NSManagedObjectContext, matching predicate: NSPredicate) -> Self? {
		if let object = materializedObject(in: context, matching: predicate) {
			return object
		} else {
			return fetch(in: context) { request in
				request.predicate = predicate
				request.returnsObjectsAsFaults = false
				request.fetchLimit = 1
			}.first
		}
	}
	
	/// Searches for an object matching the predicate. If none was found,
	/// a new object is created and the `configuration` closure is applied to it.
	///
	/// - Parameters:
	///   - context: The context in which to search or create the object.
	///   - predicate: The predicate with which to search.
	///   - configure: If no object was found this closure gets called with the newly created object passed in.
	/// - Returns: The found or created object.
	public static func findOrCreate(
		in context: NSManagedObjectContext,
		matching predicate: NSPredicate,
		configure: (Self) -> Void
	) -> Self {
		if let object = findOrFetch(in: context, matching: predicate) {
			return object
		} else {
			let newObject = Self(context: context)
			configure(newObject)
			return newObject
		}
	}
	
	/// Searches for an object matching the predicate. If none was found,
	/// a new object is created. In both cases the `configure` closure is applied to it.
	///
	/// - Parameters:
	///   - context: The context in which to search or create the object.
	///   - predicate: The predicate with which to search.
	///   - configure: This closure gets called with the found or created object passed in.
	/// - Returns: The found or created object.
	@discardableResult
	public static func updateOrCreate(
		in context: NSManagedObjectContext,
		matching predicate: NSPredicate,
		configure: (Self) -> Void
	) -> Self {
		if let object = findOrFetch(in: context, matching: predicate) {
			configure(object)
			return object
		} else {
			let newObject = Self(context: context)
			configure(newObject)
			return newObject
		}
	}
	
	public func fetched(in managedObjectContext: NSManagedObjectContext) -> Self {
		let object = managedObjectContext.object(with: objectID) as! Self // swiftlint:disable:this force_cast
		return object
	}
}
