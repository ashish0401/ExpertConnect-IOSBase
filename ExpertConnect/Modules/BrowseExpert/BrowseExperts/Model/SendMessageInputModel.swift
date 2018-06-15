//
//  SendEnquiryInputModel.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

class SendMessageInputModel {
    var senderId: String = ""
    var receiverId: String = ""
    var message: String = ""
    var command: String = ""
    var notificationType: String = ""

    init(senderId: String, receiverId: String, message : String) {
        self.senderId = senderId
        self.receiverId = receiverId
        self.message = message
        self.command = "send_notification"
        self.notificationType = "normal_message"
    }
}
