//
//  SubCategoryOutputDomainModel.swift
//  ExpertConnect
//
//  Created by Redbytes on 21/11/16.
//  Copyright © 2016 user. All rights reserved.
//

/** Use Object Mapper */
class BrowseEnquiryReceivedNotificationOutputDomainModel {
    
    var status: Bool = false
    var message: String = ""
    var browsedEnquiries: NSArray = [NSDictionary]() as NSArray
}
