//
//  FPApiModelConverter.swift
//  ExpertConnect
//
//  Created by Nadeem on 23/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import SwiftyJSON

class FPApiModelConverter {
    
    /**
     This method converts raw JSON data to model
     - parameters:
     - json: raw json data
     - returns: Authenticated User Model
     */
    func fromJson(json: JSON) -> FPOutputDomainModel {
        let status = json["status"].boolValue
        let message = json["message"].stringValue
        // Form the model to be sent
        let model: FPOutputDomainModel = FPOutputDomainModel()
        model.status = status
        model.message = message
        
        return model
    }
}
