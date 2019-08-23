//
//  Gift.swift
//  Gift Log
//
//  Created by Lee Rhodes on 8/16/19.
//  Copyright © 2019 Lee Rhodes. All rights reserved.
//

import UIKit
import os.log

class Gift: NSObject, NSCoding {
    // MARK: Properties
    
    var photo: UIImage?
    var name: String
    var store: String
    var address: String?
    var cityState: String?
    var url: String?
    var price: String
    var date: String?
    var itemCode: String?
    var priority: Int
    var contactID: String
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL: URL = DocumentsDirectory.appendingPathComponent("gifts")
    
    // MARK: Types
    
    struct GiftKey {
        static let photo = "photo"
        static let name = "name"
        static let store = "store"
        static let address = "address"
        static let cityState = "cityState"
        static let url = "url"
        static let price = "price"
        static let date = "date"
        static let itemCode = "itemCode"
        static let priority = "priority"
        static let contactID = "contactID"
    }
    
    // MARK: Initialization
    
    init?(photo: UIImage?, name: String, store: String, address: String?, cityState: String?, url: String?, price: String, date: String?, itemCode: String?, priority: Int, contactID: String) {
        
        guard !name.isEmpty else {
            return nil
        }
        
        guard !store.isEmpty else {
            return nil
        }
        
        guard (priority >= 0) && (priority <= 3) else {
            return nil
        }
        
        guard price.isNumeric && (price.floatValue >= 0) else {
            return nil
        }
        
        guard !contactID.isEmpty else {
            return nil
        }
        
        self.photo = photo
        self.name = name
        self.store = store
        self.address = address
        self.cityState = cityState
        self.url = url
        self.price = price
        self.date = date
        self.itemCode = itemCode
        self.priority = priority
        self.contactID = contactID
    }
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(photo, forKey: GiftKey.photo)
        aCoder.encode(name, forKey: GiftKey.name)
        aCoder.encode(store, forKey: GiftKey.store)
        aCoder.encode(address, forKey: GiftKey.address)
        aCoder.encode(cityState, forKey: GiftKey.cityState)
        aCoder.encode(url, forKey: GiftKey.url)
        aCoder.encode(price, forKey: GiftKey.price)
        aCoder.encode(date, forKey: GiftKey.date)
        aCoder.encode(itemCode, forKey: GiftKey.itemCode)
        aCoder.encode(priority, forKey: GiftKey.priority)
        aCoder.encode(contactID, forKey: GiftKey.contactID)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // Name, store, price, and contactID are required. If these cannot be decoded, the initalizer should fail.
        guard let name = aDecoder.decodeObject(forKey: GiftKey.name) as? String else {
            os_log("Unable to decode the name for a Gift object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let store = aDecoder.decodeObject(forKey: GiftKey.store) as? String else {
            os_log("Unable to decode the store for a Gift object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let price = aDecoder.decodeObject(forKey: GiftKey.price) as? String else {
            os_log("Unable to decode the price for a Gift object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let contactID = aDecoder.decodeObject(forKey: GiftKey.contactID) as? String else {
            os_log("Unable to decode the contactID for a Gift object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // All other properties are optional so conditional cast can be used.
        let photo = aDecoder.decodeObject(forKey: GiftKey.photo) as? UIImage
        let address = aDecoder.decodeObject(forKey: GiftKey.address) as? String
        let cityState = aDecoder.decodeObject(forKey: GiftKey.cityState) as? String
        let url = aDecoder.decodeObject(forKey: GiftKey.url) as? String
        let date = aDecoder.decodeObject(forKey: GiftKey.date) as? String
        let itemCode = aDecoder.decodeObject(forKey: GiftKey.itemCode) as? String
        
        // Priority is an Int so it doesn't need to be downcast.
        let priority = aDecoder.decodeInteger(forKey: GiftKey.priority)
        
        // Call designated initializer.
        self.init(photo: photo, name: name, store: store, address: address, cityState: cityState, url: url, price: price, date: date, itemCode: itemCode, priority: priority, contactID: contactID)
    }

}
