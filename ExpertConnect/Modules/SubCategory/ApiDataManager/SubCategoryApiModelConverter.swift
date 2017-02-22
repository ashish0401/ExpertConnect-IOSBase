//
//  SubCategoryApiModelConverter.swift
//  ExpertConnect
//
//  Created by Redbytes on 21/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import SwiftyJSON

class SubCategoryApiModelConverter {
    
    /**
     This method converts raw JSON data to model
     - parameters:
     - json: raw json data
     - returns: Authenticated User Model
     */
    func fromJson(json: JSON) -> SubCategoryOutputDomainModel {
        let subCategories = json["sub_categories"].arrayObject
        let model: SubCategoryOutputDomainModel = SubCategoryOutputDomainModel()
        model.subCategories = subCategories! as NSArray
        return model
    }
}
