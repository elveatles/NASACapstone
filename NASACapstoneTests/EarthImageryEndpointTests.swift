//
//  EarthImageryEndpointTests.swift
//  NASACapstoneTests
//
//  Created by Erik Carlson on 1/22/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import XCTest
@testable import NASACapstone

class EarthImageryEndpointTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    /// Test that the URL created by the endpoint is correct.
    func testEndpointURL() {
        let date = NasaApi.dateFormatter.date(from: "2014-02-01")
        let endpoint = EarthImageryEndpoint(lat: 1.5, lon: 100.75, dim: 0.05, date: date, cloudScore: true)
        let expectedURL = URL(string: "https://api.nasa.gov/planetary/earth/imagery?api_key=\(ApiKey.nasa)&lat=1.5&lon=100.75&dim=0.05&date=2014-02-01&cloud_score=True")!
        XCTAssertEqual(endpoint.request.url, expectedURL)
    }
}
