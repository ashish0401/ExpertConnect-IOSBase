//
//  BrowseEnquirySentNotificationApiModelConverter.swift
//  ExpertConnect
//
//  Created by Redbytes on 21/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import SwiftyJSON

class BrowseEnquirySentNotificationApiModelConverter {
    
    /**
     This method converts raw JSON data to model
     - parameters:
     - json: raw json data
     - returns: Authenticated User Model
     */
    func fromJson(json: JSON) -> BrowseEnquirySentNotificationOutputDomainModel {
        let status = json["status"].boolValue
        var browsedEnquiries = [AnyObject]()
        var message = ""
        
        if !status {
            message = json["message"].stringValue
        }
        if status {
            browsedEnquiries = json["categories"].arrayObject! as [AnyObject]
        }
        
        // Form the model to be sent
        let model: BrowseEnquirySentNotificationOutputDomainModel = BrowseEnquirySentNotificationOutputDomainModel()
        model.status = status
        model.browsedEnquiries = browsedEnquiries as NSArray
        model.message = message
        return model
    }
}
