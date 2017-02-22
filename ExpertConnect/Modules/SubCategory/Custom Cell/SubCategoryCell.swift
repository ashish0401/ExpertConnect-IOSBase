//
//  SubCategoryCell.swift
//  ExpertConnect
//
//  Created by Nadeem on 17/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit

class SubCategoryCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var lineLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
