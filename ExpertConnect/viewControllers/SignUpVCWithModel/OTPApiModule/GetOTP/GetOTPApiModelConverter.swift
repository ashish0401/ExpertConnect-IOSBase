//
//  GetOTPApiModelConverter.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import SwiftyJSON

class GetOTPApiModelConverter {
    
    /**
     This method converts raw JSON data to model
     - parameters:
     - json: raw json data
     - returns: Authenticated User Model
     */
    func fromJson(json: JSON) -> OTPOutputDomainModel {
        let status = json["status"].boolValue
        let message = json["message"].stringValue
        var OTPString = ""
        if status == true {
            OTPString = json["otp"].stringValue
        }
        // Form the model to be sent
        let model: OTPOutputDomainModel = OTPOutputDomainModel()
        model.message = message
        model.status = status
        model.OTPString = OTPString        
        return model
    }
}
