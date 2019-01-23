//
//  MockUserDefaults.swift
//  NASACapstoneTests
//
//  Created by Erik Carlson on 1/22/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import Foundation

/// Mocks UserDefaults. Stores key value pairs in memory in a dictionary called `mockData`.
class MockUserDefaults: UserDefaults {
    var mockData: [String: Any] = [:]
    
    override func set(_ value: Any?, forKey defaultName: String) {
        mockData[defaultName] = value
    }
    
    override func set(_ value: Int, forKey defaultName: String) {
        mockData[defaultName] = value
    }
    
    override func object(forKey defaultName: String) -> Any? {
        return mockData[defaultName]
    }
    
    override func string(forKey defaultName: String) -> String? {
        return mockData[defaultName] as? String
    }
    
    override func integer(forKey defaultName: String) -> Int {
        guard let value = mockData[defaultName] as? Int else {
            return 0
        }
        
        return value
    }
}
