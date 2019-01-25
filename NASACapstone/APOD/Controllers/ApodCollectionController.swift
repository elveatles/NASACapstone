//
//  ApodCollectionController.swift
//  NASACapstone
//
//  Created by Erik Carlson on 1/24/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import UIKit

/// Collection of APOD (Astronomy Picture of the Day) thumbnails which can be tapped to view the high definition image.
class ApodCollectionController: UICollectionViewController {
    /// The date formatter for section headers: Example: "January 2019".
    static let sectionDateFormatter: DateFormatter = {
        let result = DateFormatter()
        result.dateFormat = "MMMM yyyy"
        return result
    }()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    /// The number of columns to show in the collection view.
    static var columns: CGFloat = 3.0
    
    /// Data source for the collection view.
    let dataSource = ApodDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        collectionView.dataSource = dataSource
        
        setupCellSize()
        fetchNextPage()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Check if the last section will be shown.
        if indexPath.section == dataSource.sections.count - 1 {
            fetchNextPage()
        }
    }
 
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
    
    /// Setup the collection view cell sizes.
    private func setupCellSize() {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let spacing = flowLayout.minimumInteritemSpacing * 1.5
        let size = (collectionView.frame.size.width / ApodCollectionController.columns) - spacing
        flowLayout.itemSize = CGSize(width: size, height: size)
    }
    
    /// Fetch the next page of data. Each page is a month.
    func fetchNextPage() {
        activityIndicator.startAnimating()
        
        dataSource.fetchNextPage { (response) in
            self.activityIndicator.stopAnimating()
            
            switch response {
            case .success:
                if self.dataSource.sections.count == 1 {
                    self.collectionView.reloadData()
                } else {
                    let indexSet = IndexSet(integer: self.dataSource.sections.count - 1)
                    self.collectionView.insertSections(indexSet)
                }
            case .failure(let error):
                self.showAlert(title: "Download Error", message: error.localizedDescription)
            }
        }
    }
}
