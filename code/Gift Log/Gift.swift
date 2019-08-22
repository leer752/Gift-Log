//
//  Gift.swift
//  Gift Log
//
//  Created by Lee Rhodes on 8/16/19.
//  Copyright © 2019 Lee Rhodes. All rights reserved.
//

import UIKit

class Gift {
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
    
    // MARK: Initialization
    
    init?(photo: UIImage?, name: String, store: String, address: String?, cityState: String?, url: String?, price: String, date: String?, itemCode: String?, priority: Int) {
        
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
    }

}
