//
//  PromotionApiModelConverter.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import SwiftyJSON

class PromotionApiModelConverter {
    
    /**
     This method converts raw JSON data to model
     - parameters:
     - json: raw json data
     - returns: Authenticated User Model
     */
    func fromJson(json: JSON) -> PromotionOutputDomainModel {
        let status = json["status"].boolValue
        var promotions = [AnyObject]()
        if status {
            promotions = json["promotionList"].arrayObject! as [AnyObject]
        }
        // Form the model to be sent
        let model: PromotionOutputDomainModel = PromotionOutputDomainModel()
        model.status = status
        model.promotions = promotions as NSArray
        return model
    }
    
    func fromJson(json: JSON) -> MyPromotionOutputDomainModel {
        let status = json["status"].boolValue
        var promotions = [AnyObject]()
        var userId = String()
        var userName = String()
        var profilePic = String()
        var gender = String()
        var coachingDetails = [AnyObject]()
        var teacherRating = [AnyObject]()
        if status {
            userId = json["user_id"].string!
            userName = json["teacher_name"].string!
            profilePic = json["profile_pic"].string!
            gender = json["gender"].string!
            coachingDetails = json["coaching_details"].arrayObject! as [AnyObject]
            teacherRating = json["teacher_rating"].arrayObject! as [AnyObject]
            promotions = json["myPromotionList"].arrayObject! as [AnyObject]
        }
        // Form the model to be sent
        let model: MyPromotionOutputDomainModel = MyPromotionOutputDomainModel()
        model.status = status
        model.userId = userId 
        model.userName = userName 
        model.profilePic = profilePic
        model.gender = gender
        model.coachingDetails = coachingDetails as NSArray
        model.teacherRating = teacherRating as NSArray
        model.promotions = promotions as NSArray

        return model
    }

    func fromJson(json: NSDictionary) -> PromotionModel {
        let userId = json["user_id"]
        let promotionId = json["promotion_id"]
        let basePrice = json["base_price"]
        let offerDate = json["offer_date"]
        let discountPrice = json["discount_price"]
        let location = json["location"]
        let categoryName = json["category_name"]
        let subcategoryName = json["sub_category_name"]
        let userName = json["teacher_name"]
        let profilePic = json["profile_pic"]
        let gender = json["gender"]
        let descreption = json["description"]
        let blogUrl = json["blog_url"]
        let coachingDetails = json["coaching_details"]
        let teacherRating = json["teacher_rating"]

        // Form the model to be sent
        let model: PromotionModel = PromotionModel()
        model.userId = userId as! String
        model.promotionId = promotionId as! String
        model.basePrice = basePrice as! String
        model.offerDate = offerDate as! String
        model.discountPrice = discountPrice as! String
        model.location = location as! String
        model.categoryName = categoryName as! String
        model.subcategoryName = subcategoryName as! String
        model.userName = userName as! String
        model.profilePic = profilePic as! String
        model.gender = gender as! String
        model.descreption = descreption as! String
        model.blogUrl = blogUrl as! String
        model.coachingDetails = coachingDetails as! NSArray
        model.teacherRating = teacherRating as! NSArray
        //2017-09-29
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-mm-dd"
        let date = dateFormatter.date(from: model.offerDate)
        print("date: \(String(describing: date))")
        dateFormatter.dateFormat = "dd MMM, yyyy"
        let dateString = dateFormatter.string(from: date!)
        model.offerDate = dateString
        
        return model
    }
}
