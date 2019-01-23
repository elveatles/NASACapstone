//
//  EarthImageryEndpoint.swift
//  NASACapstone
//
//  Created by Erik Carlson on 1/22/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import Foundation

/// Endpoint to get data on earth imagery.
struct EarthImageryEndpoint: Endpoint {
    let lat: Double
    let lon: Double
    let dim: Double?
    let date: Date?
    let cloudScore: Bool?
    
    let base = "https://api.nasa.gov"
    let rootPath = ""
    let path = "/planetary/earth/imagery"
    
    var queryItems: [URLQueryItem] {
        // api_key
        var result = [
            URLQueryItem(name: "api_key", value: ApiKey.nasa),
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lon", value: String(lon))
        ]
        
        if let dim = dim {
            result.append(URLQueryItem(name: "dim", value: String(dim)))
        }
        
        if let date = date {
            let dateString = NasaApi.dateFormatter.string(from: date)
            result.append(URLQueryItem(name: "date", value: dateString))
        }
        
        if let cloudScore = cloudScore {
            let cloudString = cloudScore ? "True" : "False"
            result.append(URLQueryItem(name: "cloud_score", value: cloudString))
        }
        
        return result
    }
}
