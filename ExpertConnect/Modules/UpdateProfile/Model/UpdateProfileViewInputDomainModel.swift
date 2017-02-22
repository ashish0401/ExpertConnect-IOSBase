//
//  UpdateProfileViewInputDomainModel.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

class UpdateProfileViewInputDomainModel {
    var userId: String = ""
    var userType: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var emailId: String = ""
    var dob: String = ""
    var profilePic: String = ""
    var latitude: String = ""
    var longitude: String = ""
    var location: String = ""
    
    init(userId: String, userType: String, firstName : String, lastName: String, emailId: String, dob: String, profilePic: String, latitude: String, longitude: String, location: String) {
        
        self.userId = userId
        self.userType = userType
        self.firstName = firstName
        self.lastName = lastName
        self.emailId = emailId
        self.dob = dob
        self.profilePic = profilePic
        self.latitude = latitude
        self.longitude = longitude
        self.location = location
    }
}
