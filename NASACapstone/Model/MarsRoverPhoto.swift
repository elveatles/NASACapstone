//
//  MarsRoverPhoto.swift
//  NASACapstone
//
//  Created by Erik Carlson on 1/16/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import Foundation


/// Represents a page of Mars rover photos.
struct MarsRoverPhotoPage: Codable {
    let photos: [MarsRoverPhoto]
}


/// A camera on a Mars Rover.
struct MarsRoverCamera: Codable {
    let name: String
    let fullName: String
}


/// Data for a Mars rover
struct MarsRover: Codable {
    let id: Int
    let name: String
    let launchDate: Date
    let landingDate: Date
    let status: String
    let maxSol: Int
    let maxDate: Date
    let totalPhotos: Int
    let cameras: [MarsRoverCamera]
}


/// Represents photo data from the NASA Mars Rover Photo REST API.
struct MarsRoverPhoto: Codable {
    let id: Int
    let sol: Int
    let earthDate: Date
    let imgSrc: URL
    // camera
    let rover: MarsRover
}


extension MarsRoverPhoto: Equatable {
    static func == (lhs: MarsRoverPhoto, rhs: MarsRoverPhoto) -> Bool {
        return lhs.id == rhs.id
    }
}
