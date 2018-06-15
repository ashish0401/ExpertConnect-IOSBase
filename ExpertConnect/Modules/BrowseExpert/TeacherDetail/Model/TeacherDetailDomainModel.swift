//
//  BrowseExpertListDomainModel.swift
//  ExpertConnect
//
//  Created by Nadeem on 23/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
final class TeacherDetailDomainModel {

    var userId: String = ""
    var location: String = ""
    var offset: String = ""
    var limit: String = ""
    
    init(userId: String, location : String, offset: String, limit: String) {
        
        self.userId = userId
        self.location = location
        self.offset = offset
        self.limit = limit
    }
    
}
