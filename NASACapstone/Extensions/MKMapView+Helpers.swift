//
//  MKMapView+Helpers.swift
//  NASACapstone
//
//  Created by Erik Carlson on 1/23/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import MapKit

extension MKMapView {
    /// The number of meters to show for `showLocation`.
    static var areaMeters: CLLocationDistance = 500
    
    /**
     Show a location on the map.
     
     - Parameter center: The center coordinates on the map to show.
    */
    func showLocation(_ center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: MKMapView.areaMeters, longitudinalMeters: MKMapView.areaMeters)
        setRegion(region, animated: true)
    }
    
    /**
     Show a location on the map.
     
     - Parameter location: The location to show.
    */
    func showLocation(_ location: CLLocation) {
        showLocation(location.coordinate)
    }
}
