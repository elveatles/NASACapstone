//
//  MarsRoverPhotosEndpoint.swift
//  NASACapstone
//
//  Created by Erik Carlson on 1/17/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import Foundation


/// Builds endpoint URLs for the Mars Rover Photos REST API.
struct MarsRoverPhotosEndpoints {
    /// The rovers that have taken pictures on Mars.
    enum Rover: String {
        case curiosity
        case opportunity
        case spirit
    }
    
    /// Available cameras on a rover.
    enum Camera: String {
        /// Front Hazard Avoidance Camera (Curiosity, Opportunity, Spirit)
        case fhaz
        /// Rear Hazard Avoidance Camera (Curiosity, Opportunity, Spirit)
        case rhaz
        /// Mast Camera (Curiosity)
        case mast
        /// Chemistry and Camera Complex (Curiosity)
        case chemcam
        /// Mars Hand Lens Imager (Curiosity)
        case mahli
        /// Mars Descent Imager (Curiosity)
        case mardi
        /// Navigation Camera (Curiosity, Opportunity, Spirit)
        case navcam
        /// Panoramic Camera (Opportunity, Spirit)
        case pancam
        /// Miniature Thermal Emission Spectrometer (Mini-TES) (Opportunity, Spirit)
        case minites
    }
    
    /// String used to namespace/group Mars rover photos settings.
    static let userDefaultsNamespace = "MarsRoverPhotos"
    /// The base of the endpoint URLs.
    static let base = "https://api.nasa.gov"
    /// The root path of the endpoint URLs.
    static let rootPath = "/mars-photos/api/v1/rovers"
    
    /// Endpoint to get photo data for rovers.
    struct RoversPhotosEndpoint: Endpoint {
        /**
         Set the user defaults with an endpoint.
         
         Used for saving filter settings a user has made.
         
         - Parameter endpoint: The endpoint to save.
         - Parameter userDefaults: The user defaults to set.
        */
        static func setUserDefaults(with endpoint: RoversPhotosEndpoint, userDefaults: UserDefaults = .standard) {
            let namespace = MarsRoverPhotosEndpoints.userDefaultsNamespace
            userDefaults.set(endpoint.rover.rawValue, forKey: "\(namespace).rover")
            userDefaults.set(endpoint.sol, forKey: "\(namespace).sol")
            userDefaults.set(endpoint.earthDate, forKey: "\(namespace).earthDate")
            userDefaults.set(endpoint.camera?.rawValue, forKey: "\(namespace).camera")
        }
        
        /**
         Restore an endpoint from user defaults.
         
         Used to restore filter settings a user has made.
         
         - Parameter userDefaults: The user defaults to restore from.
         - Returns: The endpoint from the user defaults. nil if there are no user defaults for this endpoint or something went wrong restoring.
        */
        static func restore(from userDefaults: UserDefaults = .standard) -> RoversPhotosEndpoint? {
            let namespace = MarsRoverPhotosEndpoints.userDefaultsNamespace
            
            guard let roverString = userDefaults.string(forKey: "\(namespace).rover") else { return nil }
            guard let roverValue = Rover(rawValue: roverString) else { return nil }
            
            let solValue = userDefaults.integer(forKey: "\(namespace).sol")
            let earthDateValue = userDefaults.object(forKey: "\(namespace).earthDate") as? Date
            
            var cameraValue: Camera? = nil
            if let cameraString = userDefaults.string(forKey: "\(namespace).camera") {
                cameraValue = Camera(rawValue: cameraString)
            }
            
            // Choose initializer based on weather sol or earthDate was saved.
            if let earthDateValue = earthDateValue {
                return RoversPhotosEndpoint(
                    rover: roverValue,
                    earthDate: earthDateValue,
                    camera: cameraValue,
                    page: 1)
            } else {
                return RoversPhotosEndpoint(
                    rover: roverValue,
                    sol: solValue,
                    camera: cameraValue,
                    page: 1)
            }
        }
        
        let rover: Rover
        let sol: Int?
        let earthDate: Date?
        let camera: Camera?
        let page: Int?
        
        var base: String {
            return MarsRoverPhotosEndpoints.base
        }
        
        var rootPath: String {
            return MarsRoverPhotosEndpoints.rootPath
        }
        
        var path: String {
            return "\(rootPath)/\(rover.rawValue)/photos"
        }
        
        var queryItems: [URLQueryItem] {
            // api_key
            var result = [
                URLQueryItem(name: "api_key", value: ApiKey.nasa)
            ]
            
            // Add either sol or earthDate
            if let sol = sol {
                result.append(URLQueryItem(name: "sol", value: String(sol)))
            } else if let earthDate = earthDate {
                let value = NasaApi.dateFormatter.string(from: earthDate)
                result.append(URLQueryItem(name: "earth_date", value: value))
            } else {
                print("RoversEndpoint.queryItems Error! Neither 'sol' nor 'earthDate' have a value.")
            }
            
            // camera
            if let camera = camera {
                result.append(URLQueryItem(name: "camera", value: camera.rawValue))
            }
            
            // page
            if let page = page {
                result.append(URLQueryItem(name: "page", value: String(page)))
            }
            
            return result
        }
        
        /**
         Initialize this endpoint.
         
         - Parameter rover: The rover to get photos information from.
         - Parameter sol: The sol (1 day on mars) the picture was taken. Ranges from 0 to max found in endpoint.
         - Parameter camera: The camera to get photos information from. default: all.
         - Parameter page: The page of data. 25 items per page returned. default: 1.
        */
        init(rover: Rover, sol: Int, camera: Camera? = nil, page: Int? = nil) {
            self.rover = rover
            self.sol = sol
            self.earthDate = nil
            self.camera = camera
            self.page = page
        }
        
        /**
         Same as the other initializer, but uses earthDate instead of sol.
         
         - Parameter earthDate: The earth date that the pictures were taken.
        */
        init(rover: Rover, earthDate: Date, camera: Camera? = nil, page: Int? = nil) {
            self.rover = rover
            self.sol = nil
            self.earthDate = earthDate
            self.camera = camera
            self.page = page
        }
    }
}
