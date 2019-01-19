//
//  UITextField+Helpers.swift
//  NASACapstone
//
//  Created by Erik Carlson on 1/18/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import UIKit

extension UITextField {
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
