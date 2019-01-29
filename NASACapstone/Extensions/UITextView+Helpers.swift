//
//  UITextView+Helpers.swift
//  NASACapstone
//
//  Created by Erik Carlson on 1/21/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import UIKit

extension UITextView {
    /**
     Update the vertical alignment of the text.
     
     This is a hack because there is no built-in way of vertically aligning text for UITextViews.
     
     - Parameter verticalAlignment: The vertical alignment to use.
    */
    func updateVerticalAlignment(_ verticalAlignment: UIControl.ContentVerticalAlignment) {
        switch verticalAlignment {
        case .top, .fill:
            contentInset = UIEdgeInsets(top: 0, left: contentInset.left, bottom: 0, right: contentInset.right)
        case .center:
            let deadspace = bounds.size.height - contentSize.height
            let inset = max(0, deadspace/2.0)
            contentInset = UIEdgeInsets(top: inset, left: contentInset.left, bottom: inset, right: contentInset.right)
        case .bottom:
            let deadspace = bounds.size.height - contentSize.height
            let inset = max(0, deadspace)
            contentInset = UIEdgeInsets(top: inset, left: contentInset.left, bottom: 0, right: contentInset.right)
        }
    }
    
    /// Add a done button to the keyboard.
    func addDoneButtonToKeyboard() {
        let toolbarFrame = CGRect(x: 0, y: 0, width: 320, height: 50)
        let toolbar = UIToolbar(frame: toolbarFrame)
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        toolbar.items = [flex, doneButton]
        toolbar.sizeToFit()
        inputAccessoryView = toolbar
    }
    
    /// Resign first responder.
    @objc func doneButtonAction() {
        resignFirstResponder()
    }
}
