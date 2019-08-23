//
//  Contact.swift
//  Gift Log
//
//  Created by Lee Rhodes on 8/21/19.
//  Copyright © 2019 Lee Rhodes. All rights reserved.
//

import UIKit
import Contacts

class Contact {
    // MARK: Properties
    
    var contactName: String
    var lastName: String
    // var giftList: Array<Gift>?
    var uniqueID: String
    
    // MARK: Initialization
    
    init?(contactName: String, lastName: String, uniqueID: String) {
        guard !contactName.isEmpty else {
            return nil
        }
        
        self.contactName = contactName
        self.lastName = lastName
        self.uniqueID = uniqueID
        
    }
}
