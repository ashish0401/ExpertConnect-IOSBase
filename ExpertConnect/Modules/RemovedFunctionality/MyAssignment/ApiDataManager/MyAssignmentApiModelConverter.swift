//
//  MyAssignmentApiModelConverter.swift
//  ExpertConnect
//
//  Created by Redbytes on 21/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import SwiftyJSON

class MyAssignmentApiModelConverter {
    
    /**
     This method converts raw JSON data to model
     - parameters:
     - json: raw json data
     - returns: Authenticated User Model
     */
    func fromJson(json: JSON) -> MyAssignmentOutputDomainModel {
        let status = json["status"].boolValue
        var myAssignments = [AnyObject]()
        var message = ""
        
        if !status {
            message = json["message"].stringValue
        }
        if status {
            myAssignments = json["categories"].arrayObject! as [AnyObject]
        }
        
        // Form the model to be sent
        let model: MyAssignmentOutputDomainModel = MyAssignmentOutputDomainModel()
        model.status = status
        model.myAssignments = myAssignments as NSArray
        model.message = message
        return model
    }
}
