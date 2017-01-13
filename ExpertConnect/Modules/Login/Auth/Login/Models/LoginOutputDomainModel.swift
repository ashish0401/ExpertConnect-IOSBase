//
//  LoginOutputDomainModel.swift
//  Mezuka
//
//  Created by Hasan H. Topcu on 20/10/2016.
//  Copyright © 2016 Mezuka. All rights reserved.
//

import Foundation

/** Use Object Mapper */
class LoginOutputDomainModel {
    var userId: Int = -1
    var socialId: String = ""
    
    var firstName: String = ""
    var lastName: String = ""
    var mobileNo: String = ""
    var gender: String = ""
    var profilePic: String = ""
    var dob: String = ""
    var userType: String = ""
    
    var regType: String = ""
    var latitude: String = ""
    var longitude: String = ""
    var location: String = ""
    var countryCode: String = ""
}
