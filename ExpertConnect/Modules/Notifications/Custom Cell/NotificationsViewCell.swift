//
//  NotificationsViewCell.swift
//  ExpertConnect
//
//  Created by Redbytes on 17/01/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class NotificationsViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.makeProfileImageCircular()
    }
    private func makeProfileImageCircular() {
        self.profileImageView.layer.cornerRadius = 15.0
        self.profileImageView.clipsToBounds = true
        self.profileImageView.layer.borderWidth = CGFloat(0.0)
        self.profileImageView.layer.borderColor = UIColor.ExpertConnectBlack.cgColor
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
