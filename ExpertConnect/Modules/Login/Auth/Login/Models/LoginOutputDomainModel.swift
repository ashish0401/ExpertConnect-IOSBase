//
//  LoginOutputDomainModel.swift
//  ExpertConnect
//
//  Created by Redbytes on 20/10/2016.
//  Copyright © 2016 ExpertConnect. All rights reserved.
//

import Foundation

/** Use Object Mapper */
class LoginOutputDomainModel {
    var userId: Int = -1
    var socialId: String = ""
    
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var mobileNo: String = ""
    var gender: String = ""
    var profilePic: String = ""
    var dob: String = ""
    var userType: String = ""
    var notificationStatus: String = ""
    var currentPassword: String = ""
    
    var regType: String = ""
    var latitude: String = ""
    var longitude: String = ""
    var location: String = ""
    var countryCode: String = ""
}
