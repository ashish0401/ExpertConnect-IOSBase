//
//  MyAssignmentCustomCell.swift
//  ExpertConnect
//
//  Created by Nadeem on 18/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit

class MyAssignmentCustomCell: UITableViewCell {

    @IBOutlet var inProgressStaticLabel: UILabel!
    @IBOutlet var subjectStaticLabel: UILabel!
    @IBOutlet var locationStaticLabel: UILabel!
    @IBOutlet var coachingStaticLabel: UILabel!
    @IBOutlet var contactNoStaticLabel: UILabel!

    @IBOutlet var mainView: UIView!
    @IBOutlet var profileImageview: UIImageView!
    @IBOutlet var studentNameLabel: UILabel!
    @IBOutlet var subjectLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var coachingLabel: UILabel!
    @IBOutlet var contactNoLabel: UILabel!
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
