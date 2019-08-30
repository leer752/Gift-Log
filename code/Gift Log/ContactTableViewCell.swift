//
//  ContactTableViewCell.swift
//  Gift Log
//
//  Description: Associates storyboard layout elements to an outlet for the contact table view cells.
//
//  Created by Lee Rhodes on 8/21/19.
//  Copyright © 2019 Lee Rhodes. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var giftTotalLabel: UILabel!
    
    // Initialization.
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // View configuration for the selected state
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
