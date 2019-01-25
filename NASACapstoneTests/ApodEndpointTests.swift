//
//  ApodEndpointTests.swift
//  NASACapstoneTests
//
//  Created by Erik Carlson on 1/24/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import XCTest
@testable import NASACapstone

class ApodEndpointTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    /// Test the endpoint URL with a given date.
    func testDateURL() {
        let date = NasaApi.dateFormatter.date(from: "2019-01-20")
        let endpoint = ApodEndpoint(date: date)
        let expectedUrl = URL(string: "https://api.nasa.gov/planetary/apod?api_key=\(ApiKey.nasa)&date=2019-01-20")!
        XCTAssertEqual(endpoint.request.url!, expectedUrl)
    }
    
    /// Test the endpoint URL that takes a start and end date.
    func testStartAndEndDateURL() {
        let startDate = NasaApi.dateFormatter.date(from: "2019-01-01")!
        let endDate = NasaApi.dateFormatter.date(from: "2019-01-20")!
        let endpoint = ApodEndpoint(startDate: startDate, endDate: endDate)
        let expectedUrl = URL(string: "https://api.nasa.gov/planetary/apod?api_key=\(ApiKey.nasa)&start_date=2019-01-01&end_date=2019-01-20")!
        XCTAssertEqual(endpoint.request.url!, expectedUrl)
    }
}
