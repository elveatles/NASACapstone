//
//  MarsRoverPhotosEditController.swift
//  NASACapstone
//
//  Created by Erik Carlson on 1/21/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import UIKit
import MessageUI
import Kingfisher

/// Controller for editing a photo taken by a Mars rover.
class MarsRoverPhotosEditController: UIViewController {
    /// Address to email Mars rover postcard to.
    static let testEmailAddress = "noirelkscar@gmail.com"
    
    @IBOutlet weak var postcardView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var colorPickerCollection: UICollectionView!
    
    /// Photo to edit.
    var photo: MarsRoverPhoto!
    /// Data source for the color picker.
    let colorPickerDataSource = ColorPickerDataSource()
    /// Minimum font size for textView.
    let minFontSize: CGFloat = 8
    /// Maximum font size for textView.
    let maxFontSize: CGFloat = 64
    /// textView's default font size.
    var defaultFontSize: CGFloat = 26
    var startFontSize: CGFloat = 26
    /// Vertical alignment for `textView`.
    var verticalAlignment: UIControl.ContentVerticalAlignment = .center {
        didSet {
            textView.updateVerticalAlignment(verticalAlignment)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        textView.spellCheckingType = .no
        textView.text = ""
        defaultFontSize = textView.font?.pointSize ?? 26
        startFontSize = defaultFontSize
        textView.addDoneButtonToKeyboard()
        
        colorPickerCollection.dataSource = colorPickerDataSource
        colorPickerCollection.delegate = self
        
        /// Kingfisher caches images so it won't have to download it again.
        imageView.kf.setImage(with: photo.imgSrcHttps)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.text = "Your message!"
        textView.updateVerticalAlignment(verticalAlignment)
    }
    
    /// User is done editing the postcard.
    /// Save to photos library and email it.
    @IBAction func done(_ sender: UIBarButtonItem) {
        // The cursor will be rendered in the saved image unless textView is deselected (resign first responder).
        textView.resignFirstResponder()
        
        let renderer = UIGraphicsImageRenderer(bounds: postcardView.bounds)
        let image = renderer.image { (context) in
            postcardView.drawHierarchy(in: postcardView.bounds, afterScreenUpdates: true)
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(photoLibrary(_:didFinishSavingWithError:contextInfo:)), nil)
        
        sendMail(image: image)
    }
    
    /// Change text alignment.
    @IBAction func textSwipedLeft(_ sender: UISwipeGestureRecognizer) {
        switch textView.textAlignment {
        case .right:
            textView.textAlignment = .center
        default:
            textView.textAlignment = .left
        }
    }
    
    /// Change text alignment.
    @IBAction func textSwipedRight(_ sender: UISwipeGestureRecognizer) {
        switch textView.textAlignment {
        case .left:
            textView.textAlignment = .center
        default:
            textView.textAlignment = .right
        }
    }
    
    @IBAction func textSwipedUp(_ sender: UISwipeGestureRecognizer) {
        switch verticalAlignment {
        case .bottom:
            verticalAlignment = .center
        default:
            verticalAlignment = .top
        }
    }
    
    @IBAction func textSwipedDown(_ sender: UISwipeGestureRecognizer) {
        switch verticalAlignment {
        case .top:
            verticalAlignment = .center
        default:
            verticalAlignment = .bottom
        }
    }
    
    /// Change font size.
    @IBAction func textPinched(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .began {
            startFontSize = textView.font?.pointSize ?? defaultFontSize
        }
        
        if sender.state == .began || sender.state == .changed {
            var fontSize = startFontSize * sender.scale
            fontSize = fontSize.clamped(to: minFontSize...maxFontSize)
            textView.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
    
    /**
     Send an email using with image attachment.
     
     - Parameter image: The image to attach to the email.
    */
    func sendMail(image: UIImage) {
        guard MFMailComposeViewController.canSendMail() else {
            showAlert(
                title: "Unable to Email",
                message: "Your phone is not setup to email. Also, this feature will not work in a simulator.")
            return
        }
        
        guard let imageData = image.pngData() else {
            showAlert(title: "Bad Image Data", message: "Could not create image data to attach to email.")
            return
        }
        
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients([MarsRoverPhotosEditController.testEmailAddress])
        mail.setSubject("Postcard from Mars Rover")
        mail.setMessageBody("Wish you were here. - \(photo.rover.name)", isHTML: false)
        mail.addAttachmentData(imageData, mimeType: "image/png", fileName: "postcard.png")
        present(mail, animated: true, completion: nil)
    }
    
    @objc private func photoLibrary(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlert(title: "Save Error", message: error.localizedDescription)
            return
        }
        
        showAlert(title: "Saved!", message: "Image saved successfuly!")
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

extension MarsRoverPhotosEditController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textView.updateVerticalAlignment(verticalAlignment)
    }
}

extension MarsRoverPhotosEditController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        textView.textColor = colorPickerDataSource.getColor(for: indexPath)
    }
}

extension MarsRoverPhotosEditController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
