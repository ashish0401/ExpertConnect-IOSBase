//
//  UserServiceProtocol.swift
//  Mezuka
//
//  Created by Hasan H. Topcu on 27/09/2016.
//  Copyright © 2016 Mezuka. All rights reserved.
//

import Foundation

protocol UserServiceProtocol {
    func createUser(username: String, token: String) throws
    func updateUser(token: String) throws
    func deleteUser() throws
    func isUserAuthenticated() -> Bool
    func getAuthenticatedUser() -> User?
}