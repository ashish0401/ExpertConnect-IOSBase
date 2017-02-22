//
// Created by Redbytes.
// Copyright (c) 2016 Redbytes. All rights reserved.
//

import Foundation

/** Use Object Mapper */
final class LoginWithFacebookModel {
    var regType: String = ""
    var socialId: String = ""
    var deviceToken: String = ""
    var operatingSysType: String = ""
   // var rememberMe: Bool = false

    init(regType: String, socialId: String, deviceToken: String, operatingSysType: String) {
        self.regType = regType
        self.socialId = socialId
        self.deviceToken = deviceToken
        self.operatingSysType = operatingSysType
       // self.rememberMe = rememberMe
    }
}
