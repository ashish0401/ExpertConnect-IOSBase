//
//  TeacherFilterApiModelConverter.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import SwiftyJSON

class TeacherFilterApiModelConverter {
    
    /**
     This method converts raw JSON data to model
     - parameters:
     - json: raw json data
     - returns: Authenticated User Model
     */
    func fromJson(json: JSON) -> TeacherFilterOutputDomainModel {
        let status = json["status"].boolValue
        var categories = [AnyObject]()
        var message = ""
        if !status {
            message = json["message"].stringValue
        }
        if status {
            categories = json["categories"].arrayObject! as [AnyObject]
        }
        // Form the model to be sent
        let model: TeacherFilterOutputDomainModel = TeacherFilterOutputDomainModel()
        model.status = status
        model.categories = categories as NSArray
        model.message = message
        return model
    }
}
