//
//  PromotionDomainModel.swift
//  ExpertConnect
//
//  Created by Nadeem on 23/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
final class PromotionModel {

    var userId: String = ""
    var promotionId: String = ""
    var basePrice: String = ""
    var discountPrice: String = ""
    var offerDate: String = ""
    var location: String = ""
    var categoryName: String = ""
    var subcategoryName: String = ""
    var userName: String = ""
    var profilePic: String = ""
    var gender: String = ""
    var descreption: String = ""
    var blogUrl: String = ""
    var coachingDetails: NSArray = [NSMutableDictionary]() as NSArray
    var teacherRating: NSArray = [NSMutableDictionary]() as NSArray
}
