//
//  AddBlogViewInputDomainModel.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

class AddBlogViewInputDomainModel {
    var userId: String = ""
    var categoryId: String = ""
    var subCategoryId: String = ""
    var blogTitle: String = ""
    var blogDescription: String = ""
    var blogUrl: String = ""
    var blogCity: String = ""
    
    init(userId: String, categoryId : String, subCategoryId : String, blogTitle : String, blogDescription : String, blogUrl : String, blogCity : String) {
        self.userId = userId
        self.categoryId = categoryId
        self.subCategoryId = subCategoryId
        self.blogTitle = blogTitle
        self.blogDescription = blogDescription
        self.blogUrl = (blogUrl == "") ? " " : blogUrl   //@@@ Need to change on server side - Dummy url added
        self.blogCity = blogCity
    }
}
