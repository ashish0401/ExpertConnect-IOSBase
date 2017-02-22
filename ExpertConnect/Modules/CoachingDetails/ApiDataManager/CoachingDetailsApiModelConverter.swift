//
//  CoachingDetailsApiModelConverter.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

import SwiftyJSON

class CoachingDetailsApiModelConverter {
    
    /**
     This method converts raw JSON data to model
     - parameters:
     - json: raw json data
     - returns: Authenticated User Model
     */
    
    func fromJson(json: JSON) -> CoachingDetailsOutputDomainModel {
        let status = json["status"].boolValue
        let userId = json["user_id"].stringValue
        let userType = json["usertype"].stringValue
        let firstName = json["firstname"].stringValue
        let lastName = json["lastname"].stringValue
        let email = json["email_id"].stringValue
        let countryCode = json["country_code"].stringValue
        let mobileNo = json["mobile_no"].stringValue
        let dob = json["dob"].stringValue
        let gender = json["gender"].stringValue
        let profilePic = json["profile_pic"].stringValue
        let latitude = json["latitude"].stringValue
        let longitude = json["longitude"].stringValue
        let location = json["location"].stringValue
        let regType = json["reg_type"].stringValue
        let socialId = json["social_id"].stringValue
        let message = json["message"].stringValue
        let notificationStatus = json["notification_status"].stringValue
        let currentPassword = json["password"].stringValue
        
        // Form the model to be sent
        let model: CoachingDetailsOutputDomainModel = CoachingDetailsOutputDomainModel()
        model.status = status
        model.userId = userId
        model.userType = userType
        model.firstName = firstName
        model.lastName = lastName
        model.email = email
        model.countryCode = countryCode
        model.mobileNo = mobileNo
        model.dob = dob
        model.gender = gender
        model.profilePic = profilePic
        model.latitude = latitude
        model.longitude = longitude
        model.location = location
        model.regType = regType
        model.socialId = socialId
        model.message = message
        model.notificationStatus = notificationStatus
        model.currentPassword = currentPassword
        return model
    }
}
