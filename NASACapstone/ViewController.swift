//
//  ViewController.swift
//  NASACapstone
//
//  Created by Erik Carlson on 1/16/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var marsRoverView: UIView!
    @IBOutlet weak var marsRoverTopConstraint: NSLayoutConstraint!
    
    private let marsRoverImage = #imageLiteral(resourceName: "rover")
    private var marsRoverImageLayer = CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Nudge the Mars rover photo up a bit.
        marsRoverTopConstraint.constant = -marsRoverView.frame.height * 0.1
    }
}

