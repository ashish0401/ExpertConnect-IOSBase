//
//  UpdateCoachingDetailsInputDomainModel.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

class UpdateCoachingDetailsInputDomainModel {
    
    var userId: String = ""
    var userType: String = ""
    var coachingVenue: Array = [] as Array
    
    init(userId: String, userType: String, coachingVenue : Array<Any>) {
        self.userId = userId
        self.userType = userType
        self.coachingVenue = coachingVenue
        
    }
}
