//
//  BrowseEnquirySentNotificationOutputDomainModel.swift
//  ExpertConnect
//
//  Created by Redbytes on 21/11/16.
//  Copyright © 2016 user. All rights reserved.
//

/** Use Object Mapper */
class BrowseEnquirySentNotificationOutputDomainModel {
    
    var status: Bool = false
    var message: String = ""
    var browsedEnquiries: NSArray = [NSDictionary]() as NSArray
}
