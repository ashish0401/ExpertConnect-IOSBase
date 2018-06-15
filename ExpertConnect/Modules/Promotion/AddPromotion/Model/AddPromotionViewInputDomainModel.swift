//
//  AddBlogViewInputDomainModel.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

class AddPromotionViewInputDomainModel {
    
    // @@@Vikas
    
    var teacherId: String = ""
    var categoryId: String = ""
    var subCategoryId: String = ""
    var basePrice: String = ""
    var discountPrice: String = ""
    var offerDate: String = ""
    var description: String = ""
    var location: String = ""
    var blogUrl: String = ""

    
    init(teacherId : String, categoryId : String, subCategoryId : String, basePrice : String, discountPrice : String, offerDate : String, description : String, location : String, blogUrl : String) {
        self.teacherId = teacherId
        self.categoryId = categoryId
        self.subCategoryId = subCategoryId
        self.basePrice = basePrice
        self.discountPrice = discountPrice
        self.offerDate = offerDate
        self.description = description
        self.location = location
        self.blogUrl = (blogUrl == "") ? " " : blogUrl   //@@@ Need to change on server side - Dummy url added

    }
    
    
    /*
    //input params for Add promotion API
     
    "command":"addPromotion",
    "teacher_id":"203",
    "category_id":"4",
    "sub_category_id":"39",
    "base_price":"2000",
    "discount_price":"1000",
    "offer_date":"2017-05-01",
    "description":"Hurry offer is limited",
    "location":"Haveli",
    "blog_url":"http://sample.com/abc"
    */
}
