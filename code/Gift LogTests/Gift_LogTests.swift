//
//  Gift_LogTests.swift
//  Gift LogTests
//
//  Created by Lee Rhodes on 8/15/19.
//  Copyright © 2019 Lee Rhodes. All rights reserved.
//

import XCTest
@testable import Gift_Log

class Gift_LogTests: XCTestCase {

    // Gift Class Tests
    
    func testGiftInitalizationSucceeds() {
        let zeroPriorityGift = Gift.init(photo: nil, name: "Zero", store: "Test", address: nil, cityState: nil, url: nil, price: "0.20", date: nil, itemCode: nil, priority: 0, contactID: "id")
        XCTAssertNotNil(zeroPriorityGift)
        
        let highPriorityGift = Gift.init(photo: nil, name: "High", store: "Test", address: nil, cityState: nil, url: nil, price: "30.50", date: nil, itemCode: nil, priority: 3, contactID: "id")
        XCTAssertNotNil(highPriorityGift)
    }
    
    func testGiftInitializationFails() {
        let negativePriorityGift = Gift.init(photo: nil, name: "Negative", store: "Test", address: nil, cityState: nil, url: nil, price: "20.00", date: nil, itemCode: nil, priority: -6, contactID: "id")
        XCTAssertNil(negativePriorityGift)
        
        let noNameGift = Gift.init(photo: nil, name: "", store: "Test", address: nil, cityState: nil, url: nil, price: "0.01", date: nil, itemCode: nil, priority: 0, contactID: "id")
        XCTAssertNil(noNameGift)
        
        let negativePriceGift = Gift.init(photo: nil, name: "Free", store: "Test", address: nil, cityState: nil, url: nil, price: "-60", date: nil, itemCode: nil, priority: 0, contactID: "id")
        XCTAssertNil(negativePriceGift)
        
        let excessPriorityGift = Gift.init(photo: nil, name: "Max", store: "Test", address: nil, cityState: nil, url: nil, price: "40.00", date: nil, itemCode: nil, priority: 4, contactID: "id")
        XCTAssertNil(excessPriorityGift)
    }
    
    // Contact Class Tests
    
    func testContactInitializationSucceeds() {
        let idContact = Contact.init(contactName: "Johnny Dogood", lastName: "Dogood", uniqueID: "JD389583")
        XCTAssertNotNil(idContact)
    }
    
    func testContactInitializationFails() {
        let noNameContact = Contact.init(contactName: "", lastName: "", uniqueID: "4738")
        XCTAssertNil(noNameContact)
        
        let noIDContact = Contact.init(contactName: "Sally Supper", lastName: "Supper", uniqueID: "")
        XCTAssertNil(noIDContact)
    }
    
}

