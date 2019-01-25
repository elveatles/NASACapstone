//
//  ApodClientTests.swift
//  NASACapstoneTests
//
//  Created by Erik Carlson on 1/24/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import XCTest
@testable import NASACapstone

class ApodClientTests: XCTestCase {
    let session = MockURLSession()
    var client: ApodClient!

    override func setUp() {
        client = ApodClient(apiKey: "TEST", session: session)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testStartAndEnd() {
        // Create request. Doesn't really affect the test.
        let url = URL(string: "https://api.nasa.gov/planetary/apod")!
        
        // Get stub json to use in response.
        let bundle = Bundle(for: type(of: self))
        let jsonUrl = bundle.url(forResource: "apod_array_stub", withExtension: "json")!
        let data = try! Data(contentsOf: jsonUrl)
        // Create fake response with 200 status code.
        let httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: ["Content-Type": "application/json"])
        // Set the fake response
        session.mockDataTaskResponse = (data, httpResponse, nil)
        
        // Make the fake request.
        // This works because the callback is NOT asynchronous for MockURLSession.
        var capturedResponse: ApiResponse<[ApodItem]>?
        client.apod(startDate: Date(), endDate: Date()) { (response) in
            capturedResponse = response
        }
        
        // Create the expected result
        let date = NasaApi.dateFormatter.date(from: "2019-01-01")!
        let itemUrl = URL(string: "https://apod.nasa.gov/apod/image/1901/sombrero_spitzer_1080.jpg")!
        let expectedResult = ApodItem(date: date, title: "The Sombrero Galaxy in Infrared", explanation: "", mediaType: .image, hdurl: itemUrl, url: itemUrl)
        
        // Assert that the response is what was expected.
        switch capturedResponse! {
        case .success(let result):
            XCTAssertEqual(result[0], expectedResult)
        case .failure(let error):
            XCTFail("Error response: \(error)")
        }
    }
}
