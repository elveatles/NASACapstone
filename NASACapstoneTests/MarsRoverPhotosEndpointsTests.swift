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
    var mockUserDefaults: MockUserDefaults!

    override func setUp() {
        mockUserDefaults = MockUserDefaults(suiteName: "Tests")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    /// Test a rover endpoint using the sol initializer.
    func testRoverEndpointWithSol() {
        let endpoint = MarsRoverPhotosEndpoints.RoversPhotosEndpoint(rover: .curiosity, sol: 1000, camera: .fhaz, page: 1)
        let request = endpoint.request
        let expectedUrl = URL(string: "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?api_key=\(ApiKey.nasa)&sol=1000&camera=fhaz&page=1")
        XCTAssertEqual(request.url, expectedUrl)
    }
    
    /// Test a rover endpoint using the earthDate initializer.
    func testRoverEndpointWithEarthDate() {
        var dateComponents = DateComponents()
        dateComponents.year = 2015
        dateComponents.month = 6
        dateComponents.day = 3
        let date = Calendar.current.date(from: dateComponents)!
        let endpoint = MarsRoverPhotosEndpoints.RoversPhotosEndpoint(rover: .curiosity, earthDate: date, camera: .fhaz, page: 1)
        let request = endpoint.request
        let expectedUrl = URL(string: "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?api_key=\(ApiKey.nasa)&earth_date=2015-06-03&camera=fhaz&page=1")
        XCTAssertEqual(request.url, expectedUrl)
    }
    
    /// Test saving a "sol" endpoint to user defaults.
    func testSetUserDefaultsSol() {
        let endpoint = MarsRoverPhotosEndpoints.RoversPhotosEndpoint(rover: .curiosity, sol: 1000, camera: .fhaz, page: 1)
        MarsRoverPhotosEndpoints.RoversPhotosEndpoint.setUserDefaults(with: endpoint, userDefaults: mockUserDefaults)
        let namespace = MarsRoverPhotosEndpoints.userDefaultsNamespace
        let roverData = mockUserDefaults.mockData["\(namespace).rover"]! as! String
        let solData = mockUserDefaults.mockData["\(namespace).sol"]! as! Int
        let cameraData = mockUserDefaults.mockData["\(namespace).camera"]! as! String
        XCTAssertEqual(roverData, "curiosity")
        XCTAssertEqual(solData, 1000)
        XCTAssertEqual(cameraData, "fhaz")
        XCTAssertNil(mockUserDefaults.mockData["\(namespace).earthDate"])
    }
    
    /// Test saving a "earth date" endpoint to user defaults.
    func testSetUserDefaultsEarthDate() {
        let date = Date()
        let endpoint = MarsRoverPhotosEndpoints.RoversPhotosEndpoint(rover: .curiosity, earthDate: date, camera: .fhaz, page: 1)
        MarsRoverPhotosEndpoints.RoversPhotosEndpoint.setUserDefaults(with: endpoint, userDefaults: mockUserDefaults)
        let namespace = MarsRoverPhotosEndpoints.userDefaultsNamespace
        let roverData = mockUserDefaults.mockData["\(namespace).rover"]! as! String
        let earthDateData = mockUserDefaults.mockData["\(namespace).earthDate"]! as! Date
        let cameraData = mockUserDefaults.mockData["\(namespace).camera"]! as! String
        XCTAssertEqual(roverData, "curiosity")
        XCTAssertEqual(earthDateData, date)
        XCTAssertEqual(cameraData, "fhaz")
        XCTAssertNil(mockUserDefaults.mockData["\(namespace).sol"])
    }
    
    /// Test restoring a "sol" endpoint.
    func testRestoreSol() {
        let endpoint = MarsRoverPhotosEndpoints.RoversPhotosEndpoint(rover: .curiosity, sol: 1000, camera: .fhaz, page: 1)
        MarsRoverPhotosEndpoints.RoversPhotosEndpoint.setUserDefaults(with: endpoint, userDefaults: mockUserDefaults)
        let restoredEndpoint = MarsRoverPhotosEndpoints.RoversPhotosEndpoint.restore(from: mockUserDefaults)!
        XCTAssertEqual(restoredEndpoint.rover, .curiosity)
        XCTAssertEqual(restoredEndpoint.sol, 1000)
        XCTAssertEqual(restoredEndpoint.camera, .fhaz)
    }
    
    /// Test restoring an "earth date" endpoint.
    func testRestoreEarthDate() {
        let date = Date()
        let endpoint = MarsRoverPhotosEndpoints.RoversPhotosEndpoint(rover: .curiosity, earthDate: date, camera: .fhaz, page: 1)
        MarsRoverPhotosEndpoints.RoversPhotosEndpoint.setUserDefaults(with: endpoint, userDefaults: mockUserDefaults)
        let restoredEndpoint = MarsRoverPhotosEndpoints.RoversPhotosEndpoint.restore(from: mockUserDefaults)!
        XCTAssertEqual(restoredEndpoint.rover, .curiosity)
        XCTAssertEqual(restoredEndpoint.earthDate, date)
        XCTAssertEqual(restoredEndpoint.camera, .fhaz)
    }
}
