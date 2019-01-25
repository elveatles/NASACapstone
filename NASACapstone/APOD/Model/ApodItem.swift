//
//  ApodItem.swift
//  NASACapstone
//
//  Created by Erik Carlson on 1/24/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import Foundation

/// Media Type
enum MediaType: String, Codable {
    case image
    case video
}

/// An APOD (Astronomy Picture of the Day) item.
struct ApodItem: Codable {
    let date: Date
    let title: String
    let explanation: String
    let mediaType: MediaType
    let hdurl: URL
    let url: URL
}

extension ApodItem: Equatable {
    static func ==(lhs: ApodItem, rhs: ApodItem) -> Bool {
        return lhs.date == rhs.date && lhs.title == rhs.title
    }
}
