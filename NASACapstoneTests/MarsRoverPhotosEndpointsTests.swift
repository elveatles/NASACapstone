//
//  MarsRoverPhotosEndpointsTests.swift
//  NASACapstoneTests
//
//  Created by Erik Carlson on 1/17/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import XCTest
@testable import NASACapstone


class MarsRoverPhotosEndpointsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    /// Test a rover endpoint using the sol initializer.
    func testRoverEndpointWithSol() {
        let endpoint = MarsRoverPhotosEndpoints.RoversEndpoint(rover: .curiosity, sol: 1000, camera: .all, page: 1)
        let request = endpoint.request
        let expectedUrl = URL(string: "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?api_key=\(ApiKey.nasa)&sol=1000&camera=all&page=1")
        XCTAssertEqual(request.url, expectedUrl)
    }
    
    /// Test a rover endpoint using the earthDate initializer.
    func testRoverEndpointWithEarthDate() {
        var dateComponents = DateComponents()
        dateComponents.year = 2015
        dateComponents.month = 6
        dateComponents.day = 3
        let date = Calendar.current.date(from: dateComponents)!
        let endpoint = MarsRoverPhotosEndpoints.RoversEndpoint(rover: .curiosity, earthDate: date, camera: .all, page: 1)
        let request = endpoint.request
        let expectedUrl = URL(string: "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?api_key=\(ApiKey.nasa)&earth_date=2015-06-03&camera=all&page=1")
        XCTAssertEqual(request.url, expectedUrl)
    }
}
