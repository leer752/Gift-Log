//
//  Contact.swift
//  Gift Log
//
//  Created by Lee Rhodes on 8/21/19.
//  Copyright © 2019 Lee Rhodes. All rights reserved.
//

import UIKit
import os.log

class Contact: NSObject, NSCoding {
    // MARK: Properties
    
    var contactName: String
    var lastName: String
    var uniqueID: String
    var giftCount: Int
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL: URL = DocumentsDirectory.appendingPathComponent("contacts")
    
    // MARK: Types
    
    struct ContactKey {
        static let contactName = "contactName"
        static let lastName = "lastName"
        static let uniqueID = "uniqueID"
        static let giftCount = "giftCount"
    }
    
    // MARK: Initialization
    
    init?(contactName: String, lastName: String, uniqueID: String, giftCount: Int) {
        guard !contactName.isEmpty else {
            return nil
        }
        
        guard !uniqueID.isEmpty else {
            return nil
        }
        
        guard giftCount >= 0 else {
            return nil
        }
        
        self.contactName = contactName
        self.lastName = lastName
        self.uniqueID = uniqueID
        self.giftCount = giftCount
        
    }
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(contactName, forKey: ContactKey.contactName)
        aCoder.encode(lastName, forKey: ContactKey.lastName)
        aCoder.encode(uniqueID, forKey: ContactKey.uniqueID)
        aCoder.encode(giftCount, forKey: ContactKey.uniqueID)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // contactName, lastName, & uniqueID are required. If these cannot be decoded, the initalizer should fail.
        guard let contactName = aDecoder.decodeObject(forKey: ContactKey.contactName) as? String else {
            os_log("Unable to decode the contactName for a Contact object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let lastName = aDecoder.decodeObject(forKey: ContactKey.lastName) as? String else {
            os_log("Unable to decode the lastName for a Contact object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let uniqueID = aDecoder.decodeObject(forKey: ContactKey.uniqueID) as? String else {
            os_log("Unable to decode the uniqueID for a Contact object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let giftCount = aDecoder.decodeInteger(forKey: ContactKey.giftCount)
        
        // Call designated initializer.
        self.init(contactName: contactName, lastName: lastName, uniqueID: uniqueID, giftCount: giftCount)
    }
    
}
