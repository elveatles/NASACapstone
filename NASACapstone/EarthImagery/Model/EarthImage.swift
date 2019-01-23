//
//  EarthImage.swift
//  NASACapstone
//
//  Created by Erik Carlson on 1/22/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import Foundation

/// Data describing an image taken of the earth from space.
struct EarthImage: Codable {
    let id: String
    let date: Date
    let url: URL
}

extension EarthImage: Equatable {
    static func ==(lhs: EarthImage, rhs: EarthImage) -> Bool {
        return lhs.id == rhs.id
    }
}
