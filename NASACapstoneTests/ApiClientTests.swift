//
//  ApiClientTests.swift
//  NASACapstoneTests
//
//  Created by Erik Carlson on 1/16/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import XCTest
@testable import NASACapstone


class ApiClientTests: XCTestCase {
    let session = MockURLSession()
    var apiClient: ApiClient!
    
    override func setUp() {
        apiClient = ApiClient(apiKey: "TEST", session: session)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    /// Test an API fetch request that successfully decodes a response.
    func testFetchSuccess() {
        // Create request. Doesn't really affect the test.
        let sol = 1000
        let url = URL(string: "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?api_key=TEST&sol=\(sol)")!
        let request = URLRequest(url: url)
        
        // Get stub json to use in response.
        let bundle = Bundle(for: type(of: self))
        let jsonUrl = bundle.url(forResource: "mars_rover_photos_stub", withExtension: "json")!
        let data = try! Data(contentsOf: jsonUrl)
        // Create fake response with 200 status code.
        let httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: ["Content-Type": "application/json"])
        // Set the fake response
        session.mockDataTaskResponse = (data, httpResponse, nil)
        
        // Make the request and store the response.
        // This works because the callback is NOT asynchronous for MockURLSession.
        var optionalResponse: ApiResponse<MarsRoverPhotoPage>?
        apiClient.fetch(with: request) { (response: ApiResponse<MarsRoverPhotoPage>) in
            optionalResponse = response
        }
        
        // Create expected photo to compare actual response with.
        let imgSrc = URL(string: "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01000/opgs/edr/fcam/FLB_486265257EDR_F0481570FHAZ00323M_.JPG")!
        let expectedPhoto = MarsRoverPhoto(id: 102693, sol: sol, earthDate: Date(), imgSrc: imgSrc)
        
        // Assert that the response is what was expected.
        switch optionalResponse! {
        case .success(let result):
            let firstPhoto = result.photos.first!
            XCTAssertEqual(firstPhoto, expectedPhoto)
        default:
            XCTFail("Response is not a success.")
        }
    }
    
    /// Test an API fetch request that responds with an error.
    func testFetchFailure() {
        // Create request. Doesn't really affect the test.
        let sol = 1000
        let url = URL(string: "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?api_key=TEST&sol=\(sol)")!
        let request = URLRequest(url: url)
        
        // Try an error. Does not have to be this one in particular.
        let error = URLError(.badServerResponse)
        session.mockDataTaskResponse = (nil, nil, error)
        
        var capturedResponse: ApiResponse<MarsRoverPhotoPage>?
        apiClient.fetch(with: request) { (response) in
            capturedResponse = response
        }
        
        // Assert that the response is an error.
        switch capturedResponse! {
        case .failure(let responseError):
            let urlError = responseError as! URLError
            XCTAssertEqual(urlError, error)
        default:
            XCTFail("Response expected to be a failure.")
        }
    }
}
