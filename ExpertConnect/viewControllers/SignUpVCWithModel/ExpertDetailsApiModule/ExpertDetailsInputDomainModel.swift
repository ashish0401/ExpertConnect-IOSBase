//
//  ExpertDetailsInputDomainModel.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

class ExpertDetailsInputDomainModel {
    
    var userId: String = ""
    var categoryId: String = ""
    var subCategoryId: String = ""
    var qualification: String = ""
    var about: String = ""
    var beginner: Array = [] as Array
    var intermediate: Array = [] as Array
    var advance: Array = [] as Array
    
    init(userId: String, categoryId : String, subCategoryId : String, qualification : String, about : String, beginner : Array<Any>, intermediate : Array<Any>, advance : Array<Any>) {
        self.userId = userId
        self.categoryId = categoryId
        self.subCategoryId = subCategoryId
        self.qualification = qualification
        self.about = about
        self.beginner = beginner
        self.intermediate = intermediate
        self.advance = advance
    }
}
