//
//  SearchResultsController.swift
//  NASACapstone
//
//  Created by Erik Carlson on 1/23/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import UIKit
import MapKit

/// Shows map search results.
class SearchResultsController: UITableViewController {
    /// Data to use for the table.
    var matchingItems: [MKMapItem] = []
    /// The map view used to find locations nearby.
    var mapView: MKMapView!
    /// Callback for when a user selects a map item from the table.
    var didSelectMapItem: ((MKMapItem) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Populate the cell with the map item name and address.
        let selectedItem = matchingItems[indexPath.row]
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = selectedItem.placemark.formattedAddress

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Call the callback method for selected item.
        let item = matchingItems[indexPath.row]
        didSelectMapItem?(item)
        dismiss(animated: true, completion: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchResultsController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // Make sure we have text to search that is not whitespace.
        guard let searchText = searchController.searchBar.text,
            !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                return
        }
        
        // Create the search request.
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        // Run the search.
        search.start { (response, error) in
            if let error = error {
                print("SearchResultsController search error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response else { return }
            
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
}
