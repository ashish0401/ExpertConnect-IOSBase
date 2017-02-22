//
//  UpdateCoachingDetailsApiModelConverter.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

import SwiftyJSON

class UpdateCoachingDetailsApiModelConverter {
    
    /**
     This method converts raw JSON data to model
     - parameters:
     - json: raw json data
     - returns: Authenticated User Model
     */
    func fromJson(json: JSON) -> UpdateCoachingDetailsOutputDomainModel {
        let status = json["status"].boolValue
        var coachingDetails = [AnyObject]()
        var message = ""
        
        if !status {
            message = json["message"].stringValue
        }
        if status {
            coachingDetails = json["coaching_details"].arrayObject! as [AnyObject]
        }
        
        // Form the model to be sent
        let model: UpdateCoachingDetailsOutputDomainModel = UpdateCoachingDetailsOutputDomainModel()
        model.status = status
        model.coachingDetails = coachingDetails as NSArray
        model.message = message
        return model
    }
    
    func fromUpdateJson(json: JSON) -> UpdateCoachingDetailsOutputDomainModel {
        let status = json["status"].boolValue
        let message = json["message"].stringValue
        // Form the model to be sent
        let model: UpdateCoachingDetailsOutputDomainModel = UpdateCoachingDetailsOutputDomainModel()
        model.status = status
        model.message = message
        return model
    }
}
