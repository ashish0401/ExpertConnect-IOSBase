//
//  LoginApiModelConverter.swift
//  ExpertConnect
//
//  Created by Redbytes on 20/10/2016.
//  Copyright © 2016 ExpertConnect. All rights reserved.
//

import Foundation
import SwiftyJSON

class LoginApiModelConverter {
    
    /**
     This method converts raw JSON data to model
     - parameters:
        - json: raw json data
     - returns: Authenticated User Model
     */
    func fromJson(json: JSON) -> LoginOutputDomainModel {
        let userId = json["user_id"].intValue
        let socialId = json["social_id"].stringValue

        let firstName = json["firstname"].stringValue
        let lastName = json["lastname"].stringValue
        let mobileNo = json["mobile_no"].stringValue
        let gender = json["gender"].stringValue
        let profilePic = json["profile_pic"].stringValue
        let dob = json["dob"].stringValue
        let userType = json["usertype"].stringValue
        let email = json["email_id"].stringValue

        let regType = json["reg_type"].stringValue
        let latitude = json["latitude"].stringValue
        let longitude = json["longitude"].stringValue
        let location = json["location"].stringValue
        let countryCode = json["country_code"].stringValue
        let notificationStatus = json["notification_status"].stringValue
        let currentPassword = json["password"].stringValue

        // Form the model to be sent
        let model: LoginOutputDomainModel = LoginOutputDomainModel()
        model.userId = userId
        model.socialId = socialId
        model.firstName = firstName
        model.lastName = lastName
        model.email = email

        model.mobileNo = mobileNo
        model.gender = gender
        model.profilePic = profilePic
        model.dob = dob
        model.userType = userType
        model.regType = regType
        model.latitude = latitude
        model.longitude = longitude
        model.location = location
        model.countryCode = countryCode
        model.notificationStatus = notificationStatus
        model.currentPassword = currentPassword
        
        return model
    }
    
    func fromJsonOfPassword(json: JSON) -> FPOutputDomainModel  {
        let message = json["message"].stringValue
        let status = json["status"].boolValue
        let model: FPOutputDomainModel = FPOutputDomainModel()
        model.message = message
        model.status = status
        return model
    }
    
    func fromJsonOfFacebook(json: [String : AnyObject]) -> FacebookOutputDomainModel  {
        let userId = json["id"] as? String ?? ""
        let gender = json["gender"] as? String ?? ""
       let firstName = json["first_name"] as? String ?? ""
       let lastName = json["last_name"] as? String ?? ""
       let email = json["email"] as? String ?? ""
       let profilePicUrl = ((json["picture"] as! NSDictionary)["data"]! as! NSDictionary)["url"]! as? String ?? ""

        let model: FacebookOutputDomainModel = FacebookOutputDomainModel()
        model.userId = userId
        model.gender = gender
        model.firstName = firstName
        model.lastName = lastName
        model.email = email
        model.profilePicUrl = profilePicUrl

        return model
    }
}
