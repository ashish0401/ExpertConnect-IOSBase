//
//  NotificationsApiModelConverter.swift
//  ExpertConnect
//
//  Created by Redbytes on 21/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import SwiftyJSON

class NotificationsApiModelConverter {
    
    /**
     This method converts raw JSON data to model
     - parameters:
     - json: raw json data
     - returns: Authenticated User Model
     */
    func fromJson(json: JSON) -> NotificationsOutputDomainModel {
        let status = json["status"].boolValue
        var notifications = [AnyObject]()
        var message = ""
        
        if !status {
            message = json["message"].stringValue
        }
        if status {
            notifications = json["categories"].arrayObject! as [AnyObject]
        }
        
        // Form the model to be sent
        let model: NotificationsOutputDomainModel = NotificationsOutputDomainModel()
        model.status = status
        model.notifications = notifications as NSArray
        model.message = message
        return model
    }
    
    func fromNotificationCountJson(json: JSON) -> NotificationCountOutputDomainModel {
        let status = json["status"].boolValue
        var browseEnquiryCount: String = ""
        var myAssignmentCount: String = ""
        var notificationHistoryCount: String = ""
        if status {
            browseEnquiryCount = json["browse_inquiry_count"].stringValue
            myAssignmentCount = json["my_assignment_count"].stringValue
            notificationHistoryCount = json["notification_history_count"].stringValue
        }
        
        // Form the model to be sent
        let model: NotificationCountOutputDomainModel = NotificationCountOutputDomainModel()
        model.status = status
        model.browseEnquiryCount = browseEnquiryCount
        model.myAssignmentCount = myAssignmentCount
        model.notificationHistoryCount = notificationHistoryCount
        return model
    }

}
