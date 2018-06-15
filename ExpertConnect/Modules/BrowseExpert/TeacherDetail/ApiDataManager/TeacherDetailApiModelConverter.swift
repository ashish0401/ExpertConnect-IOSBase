//
//  BrowseExpertListApiModelConverter.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import SwiftyJSON

class TeacherDetailApiModelConverter {
    
    /**
     This method converts raw JSON data to model
     - parameters:
     - json: raw json data
     - returns: Authenticated User Model
     */
    func fromJson(json: JSON) -> TeacherDetailOutputDomainModel {
        let status = json["status"].boolValue
        var categories = [AnyObject]()
        var nextOffset: String = ""
        var totalCount: String = ""
        var message = ""
        if !status {
            message = json["message"].stringValue
        }
        if status {
            categories = json["categories"].arrayObject! as [AnyObject]
            nextOffset = json["next_offset"].stringValue
            totalCount = json["total_count"].stringValue
        }
        // Form the model to be sent
        let model: TeacherDetailOutputDomainModel = TeacherDetailOutputDomainModel()
        model.status = status
        model.categories = categories as NSArray
        model.nextOffset = nextOffset
        model.totalCount = totalCount
        model.message = message
        return model
    }
    
    func fromJson(json: NSDictionary) -> BlogViewOutputDomainModel {
        let blogId = json["id"]
        let authorName = json["author_name"]
        let blogTitle = json["blog_title"]
        let categoryName = json["category_name"]
        let subCategoryName = json["sub_category_name"]
        let profilePic = json["profile_pic"]
        let blogUrl = json["blog_url"]
        let blogDescription = json["blog_description"]
        let rating = json["rating"]
        
        var comments = [AnyObject]()
        comments = json["comments"] as! [AnyObject]
        
        // Form the model to be sent
        let model: BlogViewOutputDomainModel = BlogViewOutputDomainModel()
        model.blogId = blogId as! String
        model.authorName = authorName as! String
        model.blogTitle = blogTitle as! String
        model.categoryName = categoryName as! String
        model.subCategoryName = subCategoryName as! String
        model.profilePic = profilePic as! String
        model.blogUrl = blogUrl as! String
        model.blogDescription = blogDescription as! String
        model.rating = rating as! String
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
    
    func fromJson(json: Array<Any>) -> [BlogViewOutputDomainModel] {
        var model: [BlogViewOutputDomainModel] = []
            let blogList = json
            for blogObject in blogList {
                let blog = self.fromJson(json: blogObject as! NSDictionary) as BlogViewOutputDomainModel
                model.append(blog)
            }
        return model
    }
}
