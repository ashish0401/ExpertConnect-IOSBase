//
//  CoachingDetailsInputDomainModel.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

class CoachingDetailsInputDomainModel {
    
    var userId: String = ""
    var coachingVenue: Array = [] as Array
    
    init(userId: String, coachingVenue : Array<Any>) {
        self.userId = userId
        self.coachingVenue = coachingVenue
    }
}
