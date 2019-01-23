//
//  EarthImageryClient.swift
//  NASACapstone
//
//  Created by Erik Carlson on 1/22/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import Foundation

/// Client for the NASA Earth Imagery REST API.
class EarthImageryClient: ApiClient {
    override init(apiKey: String, session: URLSession?) {
        super.init(apiKey: apiKey, session: session)
        
        let dateFormatter = DateFormatter()
        // Same as iso8601, but missing the time zone at the end.
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
    
    /**
     Get earth imagery data.
     
     - Parameter lat: Latitude.
     - Parameter lon: Longitude.
     - Parameter dim: Width and height of image in degrees. Default: 0.025.
     - Parameter date: Date of image; If not supplied, then the most recent image (i.e., closest to today) is returned
     - Parameter cloudScore: Calculate the percentage of the image covered by clouds
    */
    func earthImagery(lat: Double, lon: Double, dim: Double? = nil, date: Date? = nil, cloudScore: Bool? = nil, completion: @escaping (ApiResponse<EarthImage>) -> Void) {
        let endpoint = EarthImageryEndpoint(lat: lat, lon: lon, dim: dim, date: date, cloudScore: cloudScore)
        fetch(with: endpoint.request, completion: completion)
    }
}
