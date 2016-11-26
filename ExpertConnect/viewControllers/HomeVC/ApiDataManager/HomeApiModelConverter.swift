//
//  HomeApiModelConverter.swift
//  ExpertConnect
//
//  Created by Redbytes on 21/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import SwiftyJSON

class HomeApiModelConverter {
    
    /**
     This method converts raw JSON data to model
     - parameters:
     - json: raw json data
     - returns: Authenticated User Model
     */
    func fromJson(json: JSON) -> HomeOutputDomainModel {
        let categories = json["categories"].arrayObject
        
        // Form the model to be sent
        let model: HomeOutputDomainModel = HomeOutputDomainModel()
        model.categories = categories! as NSArray
        return model
    }
}
