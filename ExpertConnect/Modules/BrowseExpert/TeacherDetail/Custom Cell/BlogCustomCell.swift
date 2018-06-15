//
//  BlogCustomCell.swift
//  ExpertConnect
//
//  Created by Nadeem on 18/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit
import Cosmos

class BlogCustomCell: UITableViewCell {
    @IBOutlet var titleStaticLabel: UILabel!
    @IBOutlet var mainView: UIView!
    @IBOutlet var teacherNameLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var categoryStaticLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)        // Configure the view for the selected state
    }
}
