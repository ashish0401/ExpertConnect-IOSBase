//
//  AddCategoryViewInputDomainModel.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

class AddCategoryViewInputDomainModel {
    var userId: String = ""
    var categoryName: String = ""
    var subCategoryName: String = ""
    
    init(userId: String, categoryName : String, subCategoryName : String) {
        self.userId = userId
        self.categoryName = categoryName
        self.subCategoryName = subCategoryName
    }
}
