//
//  BrowseExpertListApiModelConverter.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import SwiftyJSON

class BrowseExpertListApiModelConverter {
    
    /**
     This method converts raw JSON data to model
     - parameters:
     - json: raw json data
     - returns: Authenticated User Model
     */
    func fromJson(json: JSON) -> BrowseExpertListOutputDomainModel {
        let status = json["status"].boolValue
        var categories = [AnyObject]()
        var nextOffset: String = ""
        var totalCount: String = ""
        var message = ""
        if !status {
            message = json["message"].stringValue
        }
        if status {
            categories = json["categories"].arrayObject! as [AnyObject]
            nextOffset = json["next_offset"].stringValue
            totalCount = json["total_count"].stringValue
        }
        // Form the model to be sent
        let model: BrowseExpertListOutputDomainModel = BrowseExpertListOutputDomainModel()
        model.status = status
        model.categories = categories as NSArray
        model.nextOffset = nextOffset
        model.totalCount = totalCount
        model.message = message
        return model
    }
}
