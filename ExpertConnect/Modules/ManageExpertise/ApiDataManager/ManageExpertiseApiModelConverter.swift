//
//  BrowseEnquiryReceivedNotificationApiModelConverter.swift
//  ExpertConnect
//
//  Created by Redbytes on 21/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import SwiftyJSON

class ManageExpertiseApiModelConverter {
    
    /**
     This method converts raw JSON data to model
     - parameters:
     - json: raw json data
     - returns: Authenticated User Model
     */
    func fromJson(json: JSON) -> ManageExpertiseOutputDomainModel {
        let status = json["status"].boolValue
        var myExpertise = [AnyObject]()
        var message = ""
        
        if !status {
            message = json["message"].stringValue
        }
        if status {
            myExpertise = json["categories"].arrayObject! as [AnyObject]
        }
        
        // Form the model to be sent
        let model: ManageExpertiseOutputDomainModel = ManageExpertiseOutputDomainModel()
        model.status = status
        model.myExpertise = myExpertise as NSArray
        model.message = message
        return model
    }
}
