//
//  RegisterUserInputDomainModel.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

class RegisterUserInputDomainModel {
    
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
    var userId: String = ""

    var basePrice: String = ""
    var categoryId: String = ""
    var subCategoryId: String = ""
    var qualification: String = ""
    var about: String = ""
    var beginner: Array = [] as Array
    var intermediate: Array = [] as Array
    var advance: Array = [] as Array
    var registerCoachingVenue: Array = [] as Array

    init(userType: String, firstName: String, lastName: String, emailId: String, password: String,
         countryCode: String, mobileNo: String, dob: String, gender: String, profilePic: String,
         deviceToken: String, osType: String, latitude: String, longitude: String, location: String,
         regType: String, socialId: String,  categoryId: String, subCategoryId: String, qualification: String,
         about: String, basePrice: String, beginner : Array<Any>, intermediate : Array<Any>, advance : Array<Any>, coachingVenue : Array<Any>) {

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

        self.categoryId = categoryId
        self.subCategoryId = subCategoryId
        self.qualification = qualification
        self.about = about
        self.beginner = beginner
        self.intermediate = intermediate
        self.advance = advance
        self.basePrice = basePrice
        self.registerCoachingVenue = coachingVenue
    }
}
