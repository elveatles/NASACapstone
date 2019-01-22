//
//  ComparableHelpersTests.swift
//  NASACapstoneTests
//
//  Created by Erik Carlson on 1/21/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import XCTest
@testable import NASACapstone

class ComparableHelpersTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testClampedLower() {
        let start = -1.0
        let result = start.clamped(to: 0.0...10.0)
        XCTAssertEqual(result, 0.0, accuracy: 0.0001)
    }
    
    func testClampedUpper() {
        let start = 11.0
        let result = start.clamped(to: 0.0...10.0)
        XCTAssertEqual(result, 10.0, accuracy: 0.0001)
    }
}
