//
//  ManageExpertiseCell.swift
//  ExpertConnect
//
//  Created by Redbytes on 10/01/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class ManageExpertiseCell: UITableViewCell {

    @IBOutlet weak var mainCategoryLabel: UILabel!
    @IBOutlet weak var subCategoryLabel: UILabel!
    @IBOutlet weak var expertLevelLabel: UILabel!
    @IBOutlet weak var mainView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
