//
//  MyCategoryApiModelConverter.swift
//  ExpertConnect
//
//  Created by Redbytes on 21/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import SwiftyJSON

class MyCategoryApiModelConverter {
    
    /**
     This method converts raw JSON data to model
     - parameters:
     - json: raw json data
     - returns: Authenticated User Model
     */
    func fromJson(json: JSON) -> MyCategoryOutputDomainModel {
        let status = json["status"].boolValue
        var myCategory = [AnyObject]()
        var message = ""
        
        if !status {
            message = json["message"].stringValue
        }
        if status {
            myCategory = json["categories"].arrayObject! as [AnyObject]
        }
        
        // Form the model to be sent
        let model: MyCategoryOutputDomainModel = MyCategoryOutputDomainModel()
        model.status = status
        model.myCategory = myCategory as NSArray
        model.message = message
        return model
    }
}
