//
//  TableViewCell.swift
//  SafeHub
//
//  Created by Christopher Ho on 2018-01-28.
//  Copyright © 2018 chovo. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var lockerTitle: UILabel!
    @IBOutlet weak var lockerAvailability: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
