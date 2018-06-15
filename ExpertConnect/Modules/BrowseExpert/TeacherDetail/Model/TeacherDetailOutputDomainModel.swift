//
//  BrowseExpertListOutputDomainModel.swift
//  ExpertConnect
//
//  Created by Nadeem on 23/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
class TeacherDetailOutputDomainModel {
    //    var categories: NSArray = [NSDictionary]() as NSArray
    
    var status: Bool = false
    var categories: NSArray = [NSMutableDictionary]() as NSArray
    var nextOffset: String = ""
    var totalCount: String = ""
    var message: String = ""
}
