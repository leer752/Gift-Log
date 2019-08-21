//
//  GiftTableViewCell.swift
//  Gift Log
//
//  Created by Lee Rhodes on 8/16/19.
//  Copyright © 2019 Lee Rhodes. All rights reserved.
//

import UIKit

class GiftTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priorityControl: PriorityControl!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var giftImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
