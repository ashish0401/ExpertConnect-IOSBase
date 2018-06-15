//
//  BrowseExpertsCustomCell.swift
//  ExpertConnect
//
//  Created by Nadeem on 18/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit
import Cosmos

class MessagesCustomCell: UITableViewCell {

    @IBOutlet var mainView: UIView!
    @IBOutlet var profileImageview: UIImageView!
    @IBOutlet var teacherNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.makeProfileImageCircular()
    }
    
    private func makeProfileImageCircular() {
        self.profileImageview.layer.cornerRadius = 15.0
        self.profileImageview.clipsToBounds = true
        self.profileImageview.layer.borderWidth = CGFloat(0.0)
        self.profileImageview.layer.borderColor = UIColor.ExpertConnectBlack.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)        // Configure the view for the selected state
    }
}
