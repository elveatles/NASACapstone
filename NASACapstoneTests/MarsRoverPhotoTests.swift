//
//  MarsRoverPhotosTests.swift
//  NASACapstoneTests
//
//  Created by Erik Carlson on 1/17/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import XCTest
@testable import NASACapstone


class MarsRoverPhotoTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testImgSrcHttps() {
        let imgSrc = URL(string: "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01000/opgs/edr/fcam/FLB_486265257EDR_F0481570FHAZ00323M_.JPG")!
        let rover = MarsRover(id: 5, name: "Curiosity", launchDate: Date(), landingDate: Date(), status: "active", maxSol: 2292, maxDate: Date(), totalPhotos: 345707, cameras: [])
        let photo = MarsRoverPhoto(id: 102693, sol: 1000, earthDate: Date(), imgSrc: imgSrc, rover: rover)
        
        // Changed http to https.
        let expectedImgSrcHttps = URL(string: "https://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01000/opgs/edr/fcam/FLB_486265257EDR_F0481570FHAZ00323M_.JPG")
        XCTAssertEqual(photo.imgSrcHttps, expectedImgSrcHttps)
    }
}
