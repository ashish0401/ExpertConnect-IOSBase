//
//  verifyEmailAndMobileNoInputDomainModel.swift
//  ExpertConnect
//
//  Created by Nadeem on 23/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
final class verifyEmailAndMobileNoInputDomainModel {

    var emailId: String = ""
    var mobileNo: String = ""
    
    init(emailId: String, mobileNo : String) {
        
        self.emailId = emailId
        self.mobileNo = mobileNo
    }
}
