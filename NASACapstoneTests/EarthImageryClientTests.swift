//
//  EarthImageryClientTests.swift
//  NASACapstoneTests
//
//  Created by Erik Carlson on 1/22/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import XCTest
@testable import NASACapstone

class EarthImageryClientTests: XCTestCase {
    let session = MockURLSession()
    var client: EarthImageryClient!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        client = EarthImageryClient(apiKey: "TEST", session: session)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testEarthImagery() {
        // Create request. Doesn't really affect the test.
        let url = URL(string: "https://api.nasa.gov/planetary/earth/imagery/")!
        
        // Get stub json to use in response.
        let bundle = Bundle(for: type(of: self))
        let jsonUrl = bundle.url(forResource: "earth_imagery_stub", withExtension: "json")!
        let data = try! Data(contentsOf: jsonUrl)
        // Create fake response with 200 status code.
        let httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: ["Content-Type": "application/json"])
        // Set the fake response
        session.mockDataTaskResponse = (data, httpResponse, nil)
        
        // Make the fake request.
        // This works because the callback is NOT asynchronous for MockURLSession.
        var capturedResponse: ApiResponse<EarthImage>?
        client.earthImagery(lat: 1.5, lon: 100.75, dim: 0.05, date: Date(), cloudScore: true) { (response) in
            capturedResponse = response
        }
        
        // Create the expected result
        let expectedURL = URL(string: "https://earthengine.googleapis.com/api/thumb?thumbid=ceef02619481b11dc80e00e8148902d5&token=b11596bd2fb5b81e7fff73f869366a81")!
        let expectedResult = EarthImage(id: "LC8_L1T_TOA/LC81270592014035LGN00", date: Date(), url: expectedURL)
        
        // Assert that the response is what was expected.
        switch capturedResponse! {
        case .success(let result):
            XCTAssertEqual(result, expectedResult)
        case .failure(let error):
            XCTFail("Error response: \(error.localizedDescription)")
        }
    }
}
