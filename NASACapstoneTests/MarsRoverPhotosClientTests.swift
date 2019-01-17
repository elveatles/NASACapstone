//
//  MarsRoverPhotosClientTests.swift
//  NASACapstoneTests
//
//  Created by Erik Carlson on 1/17/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import XCTest
@testable import NASACapstone


class MarsRoverPhotosClientTests: XCTestCase {
    let session = MockURLSession()
    var marsRoversPhotosClient: MarsRoverPhotosClient!

    override func setUp() {
        marsRoversPhotosClient = MarsRoverPhotosClient(apiKey: "TEST", session: session)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    /// Test rover photos fetch with sol.
    func testRoversPhotosWithSol() {
        // Create request. Doesn't really affect the test.
        let sol = 1000
        let url = URL(string: "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?api_key=TEST&sol=\(sol)")!
        
        // Get stub json to use in response.
        let bundle = Bundle(for: type(of: self))
        let jsonUrl = bundle.url(forResource: "mars_rover_photos_stub", withExtension: "json")!
        let data = try! Data(contentsOf: jsonUrl)
        // Create fake response with 200 status code.
        let httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: ["Content-Type": "application/json"])
        // Set the fake response
        session.mockDataTaskResponse = (data, httpResponse, nil)
        
        // Make the fake request.
        // This works because the callback is NOT asynchronous for MockURLSession.
        var capturedResponse: ApiResponse<MarsRoverPhotoPage>?
        marsRoversPhotosClient.roversPhotos(rover: .curiosity, sol: sol, camera: .all, page: 1) { (response) in
            capturedResponse = response
        }
        
        // Create expected photo to compare actual response with.
        let imgSrc = URL(string: "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01000/opgs/edr/fcam/FLB_486265257EDR_F0481570FHAZ00323M_.JPG")!
        let launchDate = NasaApi.dateFormatter.date(from: "2011-11-26")!
        let landingDate = NasaApi.dateFormatter.date(from: "2012-08-06")!
        let maxDate = NasaApi.dateFormatter.date(from: "2019-01-15")!
        let rover = MarsRover(id: 5, name: "Curiosity", launchDate: launchDate, landingDate: landingDate, status: "active", maxSol: 2291, maxDate: maxDate, totalPhotos: 345681, cameras: [])
        let expectedPhoto = MarsRoverPhoto(id: 102693, sol: sol, earthDate: Date(), imgSrc: imgSrc, rover: rover)
        
        // Assert that the response is what was expected.
        switch capturedResponse! {
        case .success(let result):
            let firstPhoto = result.photos.first!
            XCTAssertEqual(firstPhoto, expectedPhoto)
        default:
            XCTFail("Response is not a success.")
        }
    }
    
    /// Test rover photos fetch with earth date.
    func testRoversPhotosWithEarthDate() {
        // Create request. Doesn't really affect the test.
        let earthDateString = "2015-06-03"
        let earthDate = NasaApi.dateFormatter.date(from: earthDateString)!
        let url = URL(string: "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?api_key=TEST&earth_date=\(earthDateString)")!
        
        // Get stub json to use in response.
        let bundle = Bundle(for: type(of: self))
        let jsonUrl = bundle.url(forResource: "mars_rover_photos_stub", withExtension: "json")!
        let data = try! Data(contentsOf: jsonUrl)
        // Create fake response with 200 status code.
        let httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: ["Content-Type": "application/json"])
        // Set the fake response
        session.mockDataTaskResponse = (data, httpResponse, nil)
        
        // Make the fake request.
        // This works because the callback is NOT asynchronous for MockURLSession.
        var capturedResponse: ApiResponse<MarsRoverPhotoPage>?
        marsRoversPhotosClient.roversPhotos(rover: .curiosity, earthDate: earthDate, camera: .all, page: 1) { (response) in
            capturedResponse = response
        }
        
        // Create expected photo to compare actual response with.
        let imgSrc = URL(string: "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01000/opgs/edr/fcam/FLB_486265257EDR_F0481570FHAZ00323M_.JPG")!
        let launchDate = NasaApi.dateFormatter.date(from: "2011-11-26")!
        let landingDate = NasaApi.dateFormatter.date(from: "2012-08-06")!
        let maxDate = NasaApi.dateFormatter.date(from: "2019-01-15")!
        let rover = MarsRover(id: 5, name: "Curiosity", launchDate: launchDate, landingDate: landingDate, status: "active", maxSol: 2291, maxDate: maxDate, totalPhotos: 345681, cameras: [])
        let expectedPhoto = MarsRoverPhoto(id: 102693, sol: 1000, earthDate: earthDate, imgSrc: imgSrc, rover: rover)
        
        // Assert that the response is what was expected.
        switch capturedResponse! {
        case .success(let result):
            let firstPhoto = result.photos.first!
            XCTAssertEqual(firstPhoto, expectedPhoto)
        default:
            XCTFail("Response is not a success.")
        }
    }
}
