//
//  PromotionOutputDomainModel.swift
//  ExpertConnect
//
//  Created by Nadeem on 23/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
class MyPromotionOutputDomainModel {
    //    var categories: NSArray = [NSDictionary]() as NSArray
    
    var status: Bool = false
    var userId: String = ""
    var userName: String = ""
    var profilePic: String = ""
    var gender: String = ""
    var coachingDetails: NSArray = [NSMutableDictionary]() as NSArray
    var teacherRating: NSArray = [NSMutableDictionary]() as NSArray
    var promotions: NSArray = [NSMutableDictionary]() as NSArray
}
