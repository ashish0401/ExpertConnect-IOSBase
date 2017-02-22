//
//  MyCategoryCell.swift
//  ExpertConnect
//
//  Created by Redbytes on 10/01/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class MyCategoryCell: UITableViewCell {

    @IBOutlet weak var mainCategoryLabel: UILabel!
    @IBOutlet weak var subCategoryLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var statusLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
