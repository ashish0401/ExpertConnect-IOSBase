//
// Created by Redbytes.
// Copyright (c) 2016 Redbytes. All rights reserved.
//

import Foundation

final class LoginViewModel {
    var email: String = ""
    var password: String = ""
    var deviceToken: String = ""
    var operatingSysType: String = ""

   // var rememberMe: Bool = false
    
    init(email: String, password: String, deviceToken: String, operatingSysType: String) {
        self.email = email
        self.password = password
        self.deviceToken = deviceToken
        self.operatingSysType = operatingSysType

     ///   self.rememberMe = rememberMe
    }
}
