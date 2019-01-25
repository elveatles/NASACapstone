//
//  ApodCell.swift
//  NASACapstone
//
//  Created by Erik Carlson on 1/24/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import UIKit
import Kingfisher

/// Cell that shows a thumbnail of a photo from APOD (Astronomy Picture of the Day)
class ApodCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    /**
     Configure with an APOD item.
     
     - Parameter apodItem: The item to configure with.
    */
    func configure(apodItem: ApodItem) {
        let placeholder = #imageLiteral(resourceName: "apod_placeholder")
        // Download the image. Resize it to thumbnail size.
        imageView.kf.setImage(with: apodItem.url, placeholder: placeholder, options: [
            .processor(DownsamplingImageProcessor(size: imageView.frame.size)),
            .scaleFactor(UIScreen.main.scale),
            .cacheOriginalImage])
    }
}
