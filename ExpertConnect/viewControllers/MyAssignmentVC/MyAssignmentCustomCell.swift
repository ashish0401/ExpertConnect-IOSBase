//
//  MyAssignmentCustomCell.swift
//  ExpertConnect
//
//  Created by Nadeem on 18/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit

class MyAssignmentCustomCell: UITableViewCell {

    @IBOutlet var Mainview: UIView!
    @IBOutlet var profileImageview: UIImageView!
    @IBOutlet var studentName: UILabel!
    @IBOutlet var inProgress: UILabel!
    @IBOutlet var subject: UILabel!
    @IBOutlet var location: UILabel!
    @IBOutlet var coaching: UILabel!
    @IBOutlet var contactNo: UILabel!
    @IBOutlet var completeButton: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
