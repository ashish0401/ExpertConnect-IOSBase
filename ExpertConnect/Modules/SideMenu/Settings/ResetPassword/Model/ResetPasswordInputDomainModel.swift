//
//  ResetPasswordInputDomainModel.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

class ResetPasswordInputDomainModel {
    var userId: String = ""
    var newPassword: String = ""
    
    init(userId: String, newPassword : String) {
        self.userId = userId
        self.newPassword = newPassword
    }
}
