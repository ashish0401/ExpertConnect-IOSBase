//
//  ExpertLevelCell.swift
//  ExpertConnect
//
//  Created by Redbytes on 17/02/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class ExpertLevelCell: UITableViewCell {

    @IBOutlet weak var beginnerButton: UIButton!
    @IBOutlet weak var intermediateButton: UIButton!
    @IBOutlet weak var advanceButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
