//
//  ApodItemController.swift
//  NASACapstone
//
//  Created by Erik Carlson on 1/25/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import UIKit
import Kingfisher
import FacebookShare

/// Shows an APOD photo with information about it.
class ApodItemController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var explanationTextView: UITextView!
    @IBOutlet weak var shareStackView: UIStackView!
    
    /// Date formatter for this view controller.
    static let dateFormatter: DateFormatter = {
        let result = DateFormatter()
        result.dateStyle = .long
        result.timeStyle = .none
        return result
    }()
    
    /// The item represented by this controller.
    var apodItem: ApodItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let shareButton = ShareButton<LinkShareContent>()
        let content = LinkShareContent(url: apodItem.url)
        shareButton.content = content
        shareStackView.addArrangedSubview(shareButton)
        
        imageView.kf.indicatorType = .activity
        configureView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // For some reason UITextView content does not start at the top.
        // This forces it to scroll to the top.
        explanationTextView.setContentOffset(.zero, animated: false)
    }
    
    /// Configure the view with the currently assigned `apodItem`.
    func configureView() {
        titleLabel.text = apodItem.title
        dateLabel.text = ApodItemController.dateFormatter.string(from: apodItem.date)
        let imageUrl = apodItem.hdurl ?? apodItem.url
        imageView.kf.setImage(with: imageUrl)
        explanationTextView.text = apodItem.explanation
    }
}
