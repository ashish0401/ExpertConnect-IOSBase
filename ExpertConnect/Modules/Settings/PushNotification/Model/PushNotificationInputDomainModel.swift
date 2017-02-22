//
//  PushNotificationInputDomainModel.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

class PushNotificationInputDomainModel {
    var userId: String = ""
    var notificationStatus: String = ""
    
    init(userId: String, notificationStatus : String) {
        self.userId = userId
        self.notificationStatus = notificationStatus
    }
}
