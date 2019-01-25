//
//  ApodClient.swift
//  NASACapstone
//
//  Created by Erik Carlson on 1/24/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import Foundation

/// Client for fetching data from the APOD (Astronomy Picture of the Day) REST API.
class ApodClient: ApiClient {
    /**
     Fetch an APOD item for a certain day.
     
     - Parameter date: The date of the picture. nil for today.
     - Parameter completion: Called with the response.
    */
    func apod(date: Date? = nil, completion: @escaping (ApiResponse<ApodItem>) -> Void) {
        let endpoint = ApodEndpoint(date: date)
        fetch(with: endpoint.request, completion: completion)
    }
    
    /**
     Fetch APOD items between a start and end date.
     
     - Parameter startData: The start date.
     - Parameter endDate: The end date.
     - Parameter completion: Called with the response.
    */
    func apod(startDate: Date, endDate: Date, completion: @escaping (ApiResponse<[ApodItem]>) -> Void) {
        let endpoint = ApodEndpoint(startDate: startDate, endDate: endDate)
        fetch(with: endpoint.request, completion: completion)
    }
}
