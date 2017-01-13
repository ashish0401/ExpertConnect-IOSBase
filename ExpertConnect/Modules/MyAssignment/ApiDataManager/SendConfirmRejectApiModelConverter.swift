//
//  SendConfirmRejectApiModelConverter.swift
//  ExpertConnect
//
//  Created by Redbytes on 09/01/17.
//  Copyright © 2017 user. All rights reserved.
//

import Foundation
import SwiftyJSON

class SendConfirmRejectApiModelConverter {
    
    /**
     This method converts raw JSON data to model
     - parameters:
     - json: raw json data
     - returns: Authenticated User Model
     */
    func fromJson(json: JSON) -> SendConfirmRejectOutputDomainModel {
        let status = json["status"].boolValue
        let message = json["message"].stringValue
        
        // Form the model to be sent
        let model: SendConfirmRejectOutputDomainModel = SendConfirmRejectOutputDomainModel()
        model.status = status
        model.message = message
        return model
    }
}
