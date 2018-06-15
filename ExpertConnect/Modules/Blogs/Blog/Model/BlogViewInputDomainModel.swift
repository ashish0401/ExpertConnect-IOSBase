//
//  AddBlogViewInputDomainModel.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

class BlogViewInputDomainModel {
    var userId: String = ""
    var blogCity: String = ""
    var command: String = ""
    
    init(userId: String, blogCity : String, command : String) {
        self.userId = userId
        self.blogCity = blogCity
        self.command = command
    }
}
