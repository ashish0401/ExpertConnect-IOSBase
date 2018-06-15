//
//  BlogRatingInputDomainModel.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

class BlogRatingInputDomainModel {
    var userId: String = ""
    var blogId: String = ""
    var rating: String = ""
    var review: String = ""
    var command: String = ""

    init(userId: String, blogId : String, rating : String, review : String, command : String) {
        self.userId = userId
        self.blogId = blogId
        self.rating = rating
        self.review = review
        self.command = command
    }
}
