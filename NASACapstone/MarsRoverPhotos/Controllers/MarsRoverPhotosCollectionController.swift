//
//  MarsRoverPhotosCollectionController.swift
//  NASACapstone
//
//  Created by Erik Carlson on 1/17/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import UIKit

/// Shows a collection of Mars Rover Photos.
class MarsRoverPhotosCollectionController: UICollectionViewController {
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    /// Data source for the collection view
    private let dataSource = MarsRoverPhotosDataSource()
    /// The number of columns for the layout.
    private let columns = 3
    /// The endpoint that represents the filters the user chose.
    private var photosEndpoint: MarsRoverPhotosEndpoints.RoversPhotosEndpoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Restore user filter settings. If there are no settings, use default values.
        if let endpoint = MarsRoverPhotosEndpoints.RoversPhotosEndpoint.restore() {
            photosEndpoint = endpoint
        } else {
            photosEndpoint = MarsRoverPhotosEndpoints.RoversPhotosEndpoint(
                rover: .curiosity, sol: 1000, camera: nil, page: 1)
        }
        
        collectionView.dataSource = dataSource
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Do any additional setup after loading the view.
        fetchPhotos()
    }
    
    /// Fetch the photos from the NASA REST API.
    func fetchPhotos() {
        activityView.startAnimating()
        
        AppDelegate.marsRoverPhotosClient.fetch(with: photosEndpoint.request) { (response: ApiResponse<MarsRoverPhotoPage>) in
            DispatchQueue.main.async {
                self.activityView.stopAnimating()
                
                switch response {
                case .success(let result):
                    self.dataSource.photos = result.photos
                    self.collectionView.reloadData()
                    print("fetch photos success")
                case .failure(let error):
                    self.showAlert(title: "Download Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMarsRoverPhotosFilters" {
            let controller = segue.destination as! MarsRoverPhotosFiltersController
            controller.endpoint = photosEndpoint
            controller.endpointUpdated = endpointUpdated
        } else if segue.identifier == "showMarsRoverPhotoEdit" {
            guard let indexPath = collectionView.indexPathsForSelectedItems?.first else {
                print("MarsRoverPhotosCollectionController.prepare: Error: No selected index path.")
                return
            }
            let controller = segue.destination as! MarsRoverPhotosEditController
            controller.photo = dataSource.object(for: indexPath)
        }
    }
    
    /// Callback for when the user has finished making their choices in the search filter view controller.
    private func endpointUpdated(newEndpoint: MarsRoverPhotosEndpoints.RoversPhotosEndpoint) {
        photosEndpoint = newEndpoint
        fetchPhotos()
    }
}


extension MarsRoverPhotosCollectionController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Size the cells according to the number of columns, not a fixed width.
        
        var spacing: CGFloat = 15
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            spacing = layout.minimumInteritemSpacing * 1.5
        }
        
        let columnWidth = collectionView.frame.size.width / CGFloat(columns)
        let side = columnWidth - spacing
        return CGSize(width: side, height: side)
    }
}
