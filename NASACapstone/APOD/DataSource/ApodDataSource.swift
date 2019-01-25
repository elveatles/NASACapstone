//
//  ApodDataSource.swift
//  NASACapstone
//
//  Created by Erik Carlson on 1/25/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import UIKit

/// Data source for the APOD collection view.
class ApodDataSource: NSObject, UICollectionViewDataSource {
    /// The date formatter for section headers: Example: "January 2019".
    static let sectionDateFormatter: DateFormatter = {
        let result = DateFormatter()
        result.dateFormat = "MMMM yyyy"
        return result
    }()
    
    /// The data source.
    /// Each outer array is a section.
    /// Each inner array is an item in the section.
    var sections: [[ApodItem]] = []
    
    /// The date to fetch. Each section is a month.
    private var dateToFetch = Date()
    /// True if a section is being fetched.
    private var isFetchingSection = false
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! ApodHeaderView
            let section = sections[indexPath.section]
            guard let item = section.first else {
                headerView.label.text = ""
                return headerView
            }
            
            headerView.label.text = ApodCollectionController.sectionDateFormatter.string(from: item.date)
            return headerView
        default:
            fatalError("ApodCollectionController.viewForSupplementaryElementOfKind: Invalid Element Type")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ApodCell
        let item = sections[indexPath.section][indexPath.row]
        cell.configure(apodItem: item)
        
        return cell
    }
    
    /// Fetch the next page of data. Each page is a month.
    /// - Parameter completion: Callback when the response happens.
    func fetchNextPage(completion: @escaping (ApiResponse<[ApodItem]>) -> Void) {
        // Make sure not to fetch the same thing more than once.
        guard !isFetchingSection else { return }
        
        isFetchingSection = true
        
        let endDate = sections.isEmpty ? Date() : dateToFetch.lastDayOfTheMonth
        
        // Fetch all pictures for the month.
        AppDelegate.apodClient.apod(startDate: dateToFetch.firstDayOfTheMonth, endDate: endDate) { (response) in
            DispatchQueue.main.async {
                self.isFetchingSection = false
                
                switch response {
                case .success(let result):
                    // Filter out anything that's not an image (videos).
                    let imagesOnly = result.filter { $0.mediaType == .image }
                    self.sections.append(imagesOnly)
                    
                    // Get the previous month.
                    self.dateToFetch = Calendar.current.date(byAdding: .month, value: -1, to: self.dateToFetch)!
                case .failure(let error):
                    print("ApodDataSource.fetchNextPage download error: \(error)")
                    
                    // At the time of writing this code, the NASA APOD API
                    // would respond with status 500 (Server error) for only
                    // the month of October 2018. This allows the app to
                    // keep fetching pages instead of blocking the app from
                    // fetching anything beyond the month of October.
                    if let apiError = error as? ApiError {
                        if case .responseUnsuccessful(let status) = apiError {
                            if status == 500 {
                                // Get the previous month.
                                self.dateToFetch = Calendar.current.date(byAdding: .month, value: -1, to: self.dateToFetch)!
                            }
                        }
                    }
                }
                
                completion(response)
            }
        }
    }
}
