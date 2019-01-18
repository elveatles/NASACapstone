//
//  MarsRoverPhotosClient.swift
//  NASACapstone
//
//  Created by Erik Carlson on 1/17/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import Foundation


/// NASA REST API for Mars rover photos.
class MarsRoverPhotosClient: ApiClient {
    /**
     Fetch rover photos using sols (Mars days).
     
     - Parameter rover: The rover to get photos information from.
     - Parameter sol: The sol (1 day on mars) the picture was taken. Ranges from 0 to max found in endpoint.
     - Parameter camera: The camera to get photos information from. default: all.
     - Parameter page: The page of data. 25 items per page returned. default: 1.
    */
    func roversPhotos(rover: MarsRoverPhotosEndpoints.Rover, sol: Int, camera: MarsRoverPhotosEndpoints.Camera? = nil, page: Int? = nil, completion: @escaping (ApiResponse<MarsRoverPhotoPage>) -> Void) {
        let endpoint = MarsRoverPhotosEndpoints.RoversPhotosEndpoint(rover: rover, sol: sol, camera: camera, page: page)
        fetch(with: endpoint.request, completion: completion)
    }
    
    /**
     Fetch rover photos using earth dates.
     
     Parameters are the same as the others except for earthDate.
     
     - Parameter earthDate: The earth date that the pictures were taken.
    */
    func roversPhotos(rover: MarsRoverPhotosEndpoints.Rover, earthDate: Date, camera: MarsRoverPhotosEndpoints.Camera? = nil, page: Int? = nil, completion: @escaping (ApiResponse<MarsRoverPhotoPage>) -> Void) {
        let endpoint = MarsRoverPhotosEndpoints.RoversPhotosEndpoint(rover: rover, earthDate: earthDate, camera: camera, page: page)
        fetch(with: endpoint.request, completion: completion)
    }
}
