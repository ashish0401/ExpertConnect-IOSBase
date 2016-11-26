//
//  SignUpApiModelConverter.swift
//  ExpertConnect
//
//  Created by Nadeem on 23/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import SwiftyJSON

class SignUpApiModelConverter {
    
    /**
     This method converts raw JSON data to model
     - parameters:
     - json: raw json data
     - returns: Authenticated User Model
     */
    func fromJson(json: JSON) -> SignUpOutputDomainModel {

        let message = json["message"].stringValue
        let status = json["status"].boolValue
        var userId = ""
        var userType = ""

        if status {
             userId = json["user_id"].stringValue
             userType = json["usertype"].stringValue
        }

        // Form the model to be sent
        let model: SignUpOutputDomainModel = SignUpOutputDomainModel()
        
        model.message = message
        model.status = status
        model.userType = userId
        model.userId = userType
        
        print(model.message)
        print(model.status)
        return model
    }
}
