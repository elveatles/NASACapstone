//
//  MarsRoverPhotosDataSource.swift
//  NASACapstone
//
//  Created by Erik Carlson on 1/18/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import UIKit

/// Data source for the Mars rover photo collection.
class MarsRoverPhotosDataSource: NSObject, UICollectionViewDataSource {
    /// The photos data
    var photos: [MarsRoverPhoto] = []
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MarsRoverPhotoCell
        
        let photo = photos[indexPath.row]
        cell.configure(photo: photo)
        
        return cell
    }
}
