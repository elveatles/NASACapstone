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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showApodPages" {
            let controller = segue.destination as! ApodPageController
            // Flatten data.
            controller.apodItems = Array(dataSource.sections.joined())
            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                controller.startingItem = dataSource.object(at: indexPath)
            }
        }
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Check if the last section will be shown.
        if indexPath.section == dataSource.sections.count - 1 {
            fetchNextPage()
        }
    }
    
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
