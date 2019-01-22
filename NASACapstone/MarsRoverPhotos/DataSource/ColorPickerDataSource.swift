//
//  ColorPickerDataSource.swift
//  NASACapstone
//
//  Created by Erik Carlson on 1/21/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import UIKit

/// Data source for the color picker.
class ColorPickerDataSource: NSObject, UICollectionViewDataSource {
    /// The colors for the user to pick from.
    let colors: [UIColor] = [.white, .lightGray, .gray, .darkGray, .black,
        #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
    ]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let cellLayer = cell.contentView.layer
        
        // Remove all sublayers
        if let sublayers = cellLayer.sublayers {
            for sublayer in sublayers {
                sublayer.removeFromSuperlayer()
            }
        }
        
        // Draw circle with the given color
        let circleLayer = CAShapeLayer()
        circleLayer.lineWidth = 2
        let rect = cellLayer.bounds.insetBy(dx: circleLayer.lineWidth * 2, dy: circleLayer.lineWidth * 2)
        circleLayer.path = UIBezierPath(ovalIn: rect).cgPath
        circleLayer.fillColor = colors[indexPath.row].cgColor
        circleLayer.strokeColor = UIColor.white.cgColor
        cellLayer.addSublayer(circleLayer)
        
        return cell
    }
    
    /**
     Get the color for the given index path.
     
     - Parameter indexPath: The index path of the color.
     - Returns: The color at the index path.
    */
    func getColor(for indexPath: IndexPath) -> UIColor {
        return colors[indexPath.row]
    }
}
