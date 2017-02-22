//
//  DeleteAccountViewInputDomainModel.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

class DeleteAccountViewInputDomainModel {
    var userId: String = ""
    var userType: String = ""
    
    init(userId: String, userType : String) {
        self.userId = userId
        self.userType = userType
    }
}
