//
//  User.swift
//  Mezuka
//
//  Created by Hasan H. Topcu on 30/09/2016.
//  Copyright © 2016 Mezuka. All rights reserved.
//

import Foundation

class User {
    var username: String = ""
    var token: String = ""
    var fullname: String = ""
    
    init() {
        
    }
    
    init(username: String, token: String, fullname: String) {
        self.username = username
        self.token = token
        self.fullname = fullname
    }
}
