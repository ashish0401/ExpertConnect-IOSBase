//
//  AddBlogViewApiModelConverter.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

import SwiftyJSON

class BlogViewApiModelConverter {
    
    /**
     This method converts raw JSON data to model
     - parameters:
     - json: raw json data
     - returns: Authenticated User Model
     */
    func fromJson(json: JSON) -> BlogViewOutputDomainModel {
        let blogId = json["id"].stringValue
        let teacherId = json["author_id"].stringValue
        let authorName = json["author_name"].stringValue
        let blogTitle = json["blog_title"].stringValue
        let categoryName = json["category_name"].stringValue
        let subCategoryName = json["sub_category_name"].stringValue
        let profilePic = json["profile_pic"].stringValue
        let blogUrl = json["blog_url"].stringValue
        let blogDescription = json["blog_description"].stringValue
        let rating = json["rating"].stringValue
        
        var comments = [AnyObject]()
        comments = json["comments"].arrayObject! as [AnyObject]
        
        // Form the model to be sent
        let model: BlogViewOutputDomainModel = BlogViewOutputDomainModel()
        model.blogId = blogId
        model.teacherId = teacherId
        model.authorName = authorName
        model.blogTitle = blogTitle
        model.categoryName = categoryName
        model.subCategoryName = subCategoryName
        model.profilePic = profilePic
        model.blogUrl = blogUrl
        model.blogDescription = blogDescription
        model.rating = rating
        model.comments = comments as NSArray
        return model
    }
    
    func fromJson(json: NSDictionary) -> CommentsDomainModel {
        let commentIndex = json["commentIndex"]
        let comment = json["comment"]
        let commentedOn = json["commented_on"]
        let commentedBy = json["commentedBy"]
        let indRating = json["indRating"]

        // Form the model to be sent
        let model: CommentsDomainModel = CommentsDomainModel()
        model.commentIndex = commentIndex as! String
        model.comment = comment as! String
        model.commentedOn = commentedOn as! String
        model.commentedBy = commentedBy as! String
        model.indRating = indRating as! String
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-mm-dd HH:mm a"
        let date = dateFormatter.date(from: model.commentedOn)
        print("date: \(String(describing: date))")
        dateFormatter.dateFormat = "dd MMM, yyyy"
        let dateString = dateFormatter.string(from: date!)
        model.commentedOn = dateString
        
        return model
    }

    func fromJson(json: JSON) -> [BlogViewOutputDomainModel] {
        var model: [BlogViewOutputDomainModel] = []
        let status = json["status"].boolValue
        if status {
            let blogList = json["blogList"].arrayValue
            for blogObject in blogList {
                let blog = self.fromJson(json: blogObject) as BlogViewOutputDomainModel
                model.append(blog)
            }
        }
        return model
    }
}
