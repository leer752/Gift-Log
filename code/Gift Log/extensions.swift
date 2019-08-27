//
//  extensions.swift
//  Gift Log
//
//  Description: Extensions to specific types that enable additional features.
//
//  Created by Lee Rhodes on 8/19/19.
//  Copyright © 2019 Lee Rhodes. All rights reserved.
//

import UIKit

//    Extensions to the String type.
//        - isNumeric
//            Tests the specified string to see if it has only numbers (or a decimal).
//            Meant to ensure that non-price-related characters are not in a string.
//            Returns: true or false.
//        - floatValue
//            Takes numeric string value and converts it into a float.
//            Returns: Float
//            NOTE: The string must be checked with "isNumeric" first. If it has non-integer characters, this extension will error out.

extension String {
    var isNumeric: Bool {
        guard !self.isEmpty else { return false }
        let numbers: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."]
        return Set(self).isSubset(of: numbers)
    }
    
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}

//    Extensions to the UITextField type.
//        - addDoneCancelToolbar
//            Inserts a toolbar at the top of the designated keyboard that gives the user a "Done" button.
//            The button dismisses the keyboard and acts the same as the "Done" buttons for other text fields.

extension UITextField {
    func addDoneToolbar(onDone: (target: Any, action: Selector)? = nil) {
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
        self.inputAccessoryView = toolbar
    }
    
    // Default action for addDoneToolbar:
    
    @objc func doneButtonTapped() { self.resignFirstResponder() }

}

