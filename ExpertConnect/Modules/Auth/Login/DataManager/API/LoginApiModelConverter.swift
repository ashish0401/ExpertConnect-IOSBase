//
//  LoginApiModelConverter.swift
//  Mezuka
//
//  Created by Hasan H. Topcu on 20/10/2016.
//  Copyright © 2016 Mezuka. All rights reserved.
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
        
        let regType = json["reg_type"].stringValue
        let latitude = json["latitude"].stringValue
        let longitude = json["longitude"].stringValue
        let location = json["location"].stringValue
        let countryCode = json["country_code"].stringValue
        
        // Form the model to be sent
        let model: LoginOutputDomainModel = LoginOutputDomainModel()
        model.userId = userId
        model.socialId = socialId
        model.firstName = firstName
        model.lastName = lastName
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
}
