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
    private var photosEndpoint = MarsRoverPhotosEndpoints.RoversPhotosEndpoint(rover: .curiosity, sol: 1000, camera: nil, page: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        }
    }
    
    /// Callback for when the user has finished making their choices in the search filter view controller.
    private func endpointUpdated(newEndpoint: MarsRoverPhotosEndpoints.RoversPhotosEndpoint) {
        photosEndpoint = newEndpoint
        fetchPhotos()
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

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
