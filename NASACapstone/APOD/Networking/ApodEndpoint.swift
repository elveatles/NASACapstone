//
//  APODEndpoint.swift
//  NASACapstone
//
//  Created by Erik Carlson on 1/24/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import Foundation

/// Endpoint for NASA APOD (Astronomy Picture of the Day) API.
struct ApodEndpoint: Endpoint {
    let base = "https://api.nasa.gov"
    let rootPath = ""
    let path = "/planetary/apod"
    
    /// The date of the APOD image. Defaults to today's date. Must be after 1995-06-16, the first day an APOD picture was posted.
    let date: Date?
    /// The start date of a date range. Cannot be used with date.
    let startDate: Date?
    /// The end date of a date range. Cannot be used with date.
    let endDate: Date?
    
    var queryItems: [URLQueryItem] {
        var result = [
            URLQueryItem(name: "api_key", value: ApiKey.nasa)
        ]
        
        if let date = date {
            let dateString = NasaApi.dateFormatter.string(from: date)
            result.append(URLQueryItem(name: "date", value: dateString))
        }
        
        if let startDate = startDate {
            let dateString = NasaApi.dateFormatter.string(from: startDate)
            result.append(URLQueryItem(name: "start_date", value: dateString))
        }
        
        if let endDate = endDate {
            let dateString = NasaApi.dateFormatter.string(from: endDate)
            result.append(URLQueryItem(name: "end_date", value: dateString))
        }
        
        return result
    }
    
    init(date: Date? = nil) {
        self.date = date
        self.startDate = nil
        self.endDate = nil
    }
    
    init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
        self.date = nil
    }
}
