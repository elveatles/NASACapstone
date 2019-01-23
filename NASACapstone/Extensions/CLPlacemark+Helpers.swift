//
//  CLPlacemark+Helpers.swift
//  NASACapstone
//
//  Created by Erik Carlson on 1/23/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import CoreLocation

extension CLPlacemark {
    /// Get a formmatted address of this placemark.
    var formattedAddress: String {
        let subThoroughfare1 = subThoroughfare ?? "" // street number
        let thoroughfare1 = thoroughfare ?? "" // street name
        let locality1 = locality ?? "" // city
        let administrativeArea1 = administrativeArea ?? "" // state
        let postalCode1 = postalCode ?? ""
        
        return "\(subThoroughfare1) \(thoroughfare1), \(locality1) \(administrativeArea1) \(postalCode1)"
    }
}
