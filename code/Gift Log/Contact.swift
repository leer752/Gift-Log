//
//  Contact.swift
//  Gift Log
//
//  Created by Lee Rhodes on 8/21/19.
//  Copyright © 2019 Lee Rhodes. All rights reserved.
//

import UIKit

class Contact {
    // MARK: Properties
    
    var contactName: String
    var lastName: String
    var uniqueID: String
    var giftCount: Int
    
    // MARK: Initialization
    
    init?(contactName: String, lastName: String, uniqueID: String, giftCount: Int) {
        guard !contactName.isEmpty else { return nil }
        
        guard !uniqueID.isEmpty else { return nil }
        
        guard giftCount >= 0 else { return nil }
        
        self.contactName = contactName
        self.lastName = lastName
        self.uniqueID = uniqueID
        self.giftCount = giftCount
        
    }
}
