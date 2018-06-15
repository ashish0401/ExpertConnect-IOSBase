//
//  SendRequestApiModelConverter.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import SwiftyJSON

class SendRequestApiModelConverter {
    
    /**
     This method converts raw JSON data to model
     - parameters:
     - json: raw json data
     - returns: Authenticated User Model
     */
    func fromJson(json: JSON) -> SendRequestOutputDomainModel {
        let status = json["status"].boolValue
        let message = json["message"].stringValue
        
        // Form the model to be sent
        let model: SendRequestOutputDomainModel = SendRequestOutputDomainModel()
        model.status = status
        model.message = message
        return model
    }
}
