//
//  EarthImageController.swift
//  NASACapstone
//
//  Created by Erik Carlson on 1/23/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import UIKit
import Kingfisher

/// Downloads a NASA earth image and displays it to the user.
class EarthImageryController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var endpoint: EarthImageryEndpoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.kf.indicatorType = .activity
        
        // Fetch the image data, then download the image.
        AppDelegate.earthImageryClient.fetch(with: endpoint.request) { (response: ApiResponse<EarthImage>) in
            DispatchQueue.main.async {
                switch response {
                case .success(let result):
                    self.imageView.kf.setImage(with: result.url)
                case .failure(let error):
                    print("EarthImageryController.viewDidLoad fetch error: \(error.localizedDescription)")
                    self.showAlert(title: "Download Error", message: error.localizedDescription)
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
