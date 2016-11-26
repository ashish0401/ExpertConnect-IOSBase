//
//  UserService.swift
//  Mezuka
//
//  Created by Hasan H. Topcu on 27/09/2016.
//  Copyright © 2016 Mezuka. All rights reserved.
//

import Foundation
import Locksmith

class UserService: UserServiceProtocol {
    static let sharedInstance: UserServiceProtocol = UserService()
    private let sessionIndicator = "current"
    private let service = "com.mezuka.Mezuka"
    
    // To make sure that this class cannot be instantiated outside
    private init() {}
    
    /**
     This creates a new user
    */
    func createUser(username: String, token: String) throws{
        do {
            if (isUserAuthenticated()) {
                try deleteUser()
            }
            try Locksmith.saveData(data: ["username": username, "token": token], forUserAccount: sessionIndicator, inService: service)
        } catch {
            throw EUserServiceError.UnknownError
        }
    }
    
    func updateUser(token: String) throws{
        do {
            try Locksmith.updateData(data: ["token": token], forUserAccount: sessionIndicator, inService: service)
        } catch {
            throw EUserServiceError.UnknownError
        }
    }
    
    func deleteUser() throws{
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: sessionIndicator, inService: service)
        } catch {
            throw EUserServiceError.UnknownError
        }
    }
    
    func isUserAuthenticated() -> Bool {
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: sessionIndicator, inService: service)
        return dictionary?.isEmpty == false
    }
    
    func getAuthenticatedUser() -> User? {
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: sessionIndicator, inService: service)
        if(dictionary?.isEmpty == false) {
            let username = dictionary?["username"]
            let token = dictionary?["token"]
            let fullname = "Hasan H. Topcu"
            
            return User(username: username as! String, token: token as! String, fullname: fullname)
        }
        
        return nil
    }
}
