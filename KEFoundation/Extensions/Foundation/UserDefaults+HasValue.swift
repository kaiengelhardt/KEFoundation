//
//  File.swift
//
//
//  Created by Kai Engelhardt on 14.01.23.
//

import Foundation

extension UserDefaults {
	public func hasValue(forKey key: String) -> Bool {
		return object(forKey: key) != nil
	}
}
