//
//  ResetPasswordApiModelConverter.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

import SwiftyJSON

class ResetPasswordApiModelConverter {
    
    /**
     This method converts raw JSON data to model
     - parameters:
     - json: raw json data
     - returns: Authenticated User Model
     */
    func fromResetPasswordJson(json: JSON) -> OTPOutputDomainModel {
        let status = json["status"].boolValue
        let message = json["message"].stringValue
        // Form the model to be sent
        let model: OTPOutputDomainModel = OTPOutputDomainModel()
        model.message = message
        model.status = status
        return model
    }
}
