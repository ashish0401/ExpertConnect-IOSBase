//
//  BrowseEnquirySentNotificationCustomCell.swift
//  ExpertConnect
//
//  Created by Nadeem on 18/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit
import Cosmos

class BrowseEnquirySentNotificationCustomCell: UITableViewCell {
    
    @IBOutlet var starView: CosmosView!
    @IBOutlet var locationStaticLabel: UILabel!
    @IBOutlet var feeStaticLabel: UILabel!
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var profileImageview: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var subCategoryNameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var feeLabel: UILabel!
    @IBOutlet var requestSentButton: UIButton!
    
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
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
