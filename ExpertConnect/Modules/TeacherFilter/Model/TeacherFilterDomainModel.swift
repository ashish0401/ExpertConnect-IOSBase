//
//  TeacherFilterDomainModel.swift
//  ExpertConnect
//
//  Created by Nadeem on 23/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
final class TeacherFilterDomainModel {

    var userId: String = ""
    var categoryId: String = ""
    var subCategoryId: String = ""
    var level: String = ""
    var coachingVenue: Array = [] as Array
    
    init(userId: String, categoryId : String, subCategoryId: String, level: String, coachingVenue : Array<Any>) {
        
        self.userId = userId
        self.categoryId = categoryId
        self.subCategoryId = subCategoryId
        self.level = level
        self.coachingVenue = coachingVenue
    }
    
}
