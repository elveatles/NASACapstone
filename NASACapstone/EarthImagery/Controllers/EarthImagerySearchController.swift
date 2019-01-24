//
//  EarthImagerySearchController.swift
//  NASACapstone
//
//  Created by Erik Carlson on 1/23/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import UIKit
import MapKit

/// The controller for searching for a location on a map.
class EarthImagerySearchController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    /// Search controller used to search for locations by name.
    lazy var searchController: UISearchController = {
        // Create search results table from storyboard.
        let identifier = String(describing: SearchResultsController.self)
        let searchResultsController = storyboard!.instantiateViewController(withIdentifier: identifier) as! SearchResultsController
        searchResultsController.mapView = mapView
        searchResultsController.didSelectMapItem = didSelectMapItem
        // Create search controller and setup.
        let result = UISearchController(searchResultsController: searchResultsController)
        result.searchBar.sizeToFit()
        result.searchBar.placeholder = "Search for places"
        result.searchResultsUpdater = searchResultsController
        return result
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = searchController
        definesPresentationContext = true

        AppDelegate.locationManager.delegate = self
        AppDelegate.locationManager.requestWhenInUseAuthorization()
        AppDelegate.locationManager.requestLocation()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showEarthImagery" {
            let controller = segue.destination as! EarthImageryController
            let region = mapView.region
            let dim = min(region.span.latitudeDelta, region.span.longitudeDelta)
            let endpoint = EarthImageryEndpoint(lat: region.center.latitude, lon: region.center.longitude, dim: dim)
            controller.endpoint = endpoint
        }
    }

    /// Show the user's current location on the map.
    @IBAction func showCurrentLocation(_ sender: UIBarButtonItem) {
        mapView.showLocation(mapView.userLocation.coordinate)
    }
    
    /**
     Show an annotation on the map.
     
     - Parameter coordinate: The coordinate of the annotation.
     - Parameter title: The title of the annotation.
     - Parameter subtitle: The subtitle of the annotation.
    */
    func showAnnotation(at coordinate: CLLocationCoordinate2D, title: String) {
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        let latitude = String(format: "%.3f", coordinate.latitude)
        let longitude = String(format: "%.3f", coordinate.longitude)
        annotation.subtitle = "Lat: \(latitude)\nLon: \(longitude)"
        mapView.addAnnotation(annotation)
        mapView.showLocation(coordinate)
    }
    
    /// Add an annotation in the map view.
    private func didSelectMapItem(_ mapItem: MKMapItem) {
        let title = mapItem.name ?? "Location"
        showAnnotation(at: mapItem.placemark.coordinate, title: title)
    }
}

extension EarthImagerySearchController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        mapView.showLocation(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManager didFailWithError: \(error.localizedDescription)")
    }
}
