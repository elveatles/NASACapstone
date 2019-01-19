//
//  MarsRoverPhotoCell.swift
//  NASACapstone
//
//  Created by Erik Carlson on 1/17/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import UIKit
import Kingfisher

/// Cell for the Mars Rover Photos collection view.
class MarsRoverPhotoCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    /**
     Configure this cell with a photo.
     
     - Parameter photo: The photo to configure with.
    */
    func configure(photo: MarsRoverPhoto) {
        let placeholder = #imageLiteral(resourceName: "photo_placeholder")
        let size = imageView.frame.size
        
        // Download image and resize it to the imageView size.
        // More info at: https://github.com/onevcat/Kingfisher/wiki/Cheat-Sheet#using-downsamplingimageprocessor-for-high-resolution-images
        imageView.kf.setImage(
            with: photo.imgSrcHttps,
            placeholder: placeholder,
            options: [
                .processor(DownsamplingImageProcessor(size: size)),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ])
    }
}
