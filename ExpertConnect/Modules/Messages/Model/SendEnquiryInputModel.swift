//
//  SendEnquiryInputModel.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

class SendEnquiryInputModel {
    var userId: String = ""
    var message: String = ""
    var command: String = ""

    init(userId: String, message : String, command : String) {
        self.userId = userId
        self.message = message
        self.command = command
    }
}
