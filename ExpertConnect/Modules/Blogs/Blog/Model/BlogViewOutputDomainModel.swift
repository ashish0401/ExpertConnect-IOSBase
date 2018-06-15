//
//  AddBlogViewInputDomainModel.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

class BlogViewOutputDomainModel {
    var status = false
    var blogId = ""
    var teacherId = ""
    var authorName = ""
    var blogTitle = ""
    var categoryName = ""
    var subCategoryName = ""
    var profilePic = ""
    var blogUrl = ""
    var blogDescription = ""
    var rating = ""
    var comments: NSArray = [NSDictionary]() as NSArray
}
