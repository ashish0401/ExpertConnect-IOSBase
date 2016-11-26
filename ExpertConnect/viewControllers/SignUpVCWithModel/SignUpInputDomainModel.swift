//
//  SignUpInputDomainModel.swift
//  ExpertConnect
//
//  Created by Nadeem on 23/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
final class SignUpInputDomainModel {

    var userType: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var emailId: String = ""
    var password: String = ""
    var countryCode: String = ""
    var mobileNo: String = ""
    var dob: String = ""
    var gender: String = ""
    var profilePic: String = ""
    var deviceToken: String = ""
    var osType: String = ""
    var latitude: String = ""
    var longitude: String = ""
    var location: String = ""
    var regType: String = ""
    var socialId: String = ""
    
    init(userType: String, firstName : String, lastName: String, emailId: String, password: String, countryCode: String, mobileNo: String, dob: String, gender: String, profilePic: String, deviceToken: String, osType: String, latitude: String, longitude: String, location: String,  regType: String, socialId: String) {
        
        self.userType = userType
        self.firstName = firstName
        self.lastName = lastName
        self.emailId = emailId
        self.password = password
        self.countryCode = countryCode
        self.mobileNo = mobileNo
        self.dob = dob
        self.gender = gender
        self.profilePic = profilePic
        self.deviceToken = deviceToken
        self.osType = osType
        self.latitude = latitude
        self.longitude = longitude
        self.location = location
        self.regType = regType
        self.socialId = socialId
    }
    
}
