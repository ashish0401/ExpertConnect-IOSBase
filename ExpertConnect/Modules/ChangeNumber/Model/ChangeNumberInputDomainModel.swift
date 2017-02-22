//
//  ChangeNumberInputDomainModel.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

class ChangeNumberInputDomainModel {
    var userId: String = ""
    var newMobileNumber: String = ""
    var countryCode: String = ""
    
    init(userId: String, countryCode: String, newMobileNumber : String) {
        self.userId = userId
        self.newMobileNumber = newMobileNumber
        self.countryCode = countryCode
    }
}
