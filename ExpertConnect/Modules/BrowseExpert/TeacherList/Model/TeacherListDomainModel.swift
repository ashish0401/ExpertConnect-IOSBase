//
//  TeacherListDomainModel.swift
//  ExpertConnect
//
//  Created by Nadeem on 23/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
final class TeacherListDomainModel {

    var userId: String = ""
    var categoryId: String = ""
    var subCategoryId: String = ""
    
    init(userId: String, categoryId : String, subCategoryId: String) {
        
        self.userId = userId
        self.categoryId = categoryId
        self.subCategoryId = subCategoryId
    }
}
