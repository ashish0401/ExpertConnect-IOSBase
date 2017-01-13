//
//  VerifyOTPInputDomainModel.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

class VerifyOTPInputDomainModel {
    var OTPString: String = ""
    var mobile_no: String = ""
    
    init(OTPString: String, mobile_no : String) {
        self.OTPString = OTPString
        self.mobile_no = mobile_no
    }
}
