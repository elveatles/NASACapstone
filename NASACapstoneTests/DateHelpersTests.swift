//
//  DateHelpersTests.swift
//  NASACapstoneTests
//
//  Created by Erik Carlson on 1/25/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import XCTest
@testable import NASACapstone

class DateHelpersTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFirstDayOfTheMonth() {
        var dateComponents = DateComponents()
        dateComponents.year = 2019
        dateComponents.month = 1
        dateComponents.day = 20
        let date = Calendar.current.date(from: dateComponents)!
        let firstDay = date.firstDayOfTheMonth
        let firstDayComponents = Calendar.current.dateComponents([.year, .month, .day], from: firstDay)
        XCTAssertEqual(firstDayComponents.year, 2019)
        XCTAssertEqual(firstDayComponents.month, 1)
        XCTAssertEqual(firstDayComponents.day, 1)
    }
    
    func testLastDayOfTheMonth() {
        var dateComponents = DateComponents()
        dateComponents.year = 2019
        dateComponents.month = 1
        dateComponents.day = 20
        let date = Calendar.current.date(from: dateComponents)!
        let lastDay = date.lastDayOfTheMonth
        let lastDayComponents = Calendar.current.dateComponents([.year, .month, .day], from: lastDay)
        XCTAssertEqual(lastDayComponents.year, 2019)
        XCTAssertEqual(lastDayComponents.month, 1)
        XCTAssertEqual(lastDayComponents.day, 31)
    }
}
