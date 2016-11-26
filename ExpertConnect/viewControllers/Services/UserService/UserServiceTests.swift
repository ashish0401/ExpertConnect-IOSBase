//
//  UserServiceTests.swift
//  Mezuka
//
//  Created by Hasan H. Topcu on 27/09/2016.
//  Copyright © 2016 Mezuka. All rights reserved.
//

import XCTest
import Locksmith
@testable import Mezuka

/** Integration test for UserService
 
    In order to use the keychain from the test target, share Locksmith with another target
    https://github.com/matthewpalmer/Locksmith/issues/146
    http://evgenii.com/blog/sharing-keychain-in-ios/
 */
class UserServiceTests: XCTestCase {
    var sut: UserServiceProtocol!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        do {
            sut = UserService.sharedInstance
            // Make sure details about the current user is deleted
            let dictionary = Locksmith.loadDataForUserAccount(userAccount: "current", inService: "com.mezuka.Mezuka")
            if dictionary != nil {
                try Locksmith.deleteDataForUserAccount(userAccount: "current", inService: "com.mezuka.Mezuka")
            }
        } catch let error {
            print(error.localizedDescription)
            XCTFail()
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateUser() {
        let username = "secret_username"
        let token = "secret_token"
        
        do {
            try sut.createUser(username: username, token: token)
            let dictionary = Locksmith.loadDataForUserAccount(userAccount: "current", inService: "com.mezuka.Mezuka")
            XCTAssert(sut.isUserAuthenticated() == true)
            XCTAssert(dictionary!["username"] as! String == "secret_username")
            XCTAssert(dictionary!["token"] as! String == "secret_token")
        } catch let error {
            print(error.localizedDescription)
            XCTFail()
        }
    }
    
    func testDeleteUser() {
        let username = "secret_username"
        let token = "secret_token"
        
        do {
            try Locksmith.saveData(data: ["username": username, "token": token], forUserAccount: "current")
            XCTAssert(sut.isUserAuthenticated() == true)
            try sut.deleteUser()
            XCTAssert(sut.isUserAuthenticated() == false)
        } catch let error {
            print(error.localizedDescription)
            XCTFail()
        }
    }
    
    func testUpdateUser() {
        let username = "secret_username"
        let token = "secret_token"
        
        do {
            try Locksmith.saveData(data: ["username": username, "token": token], forUserAccount: "current")
            try sut.updateUser(token: "another_secure_token")
            let dictionary = Locksmith.loadDataForUserAccount(userAccount: "current", inService: "com.mezuka.Mezuka")
            print(dictionary!["token"] as! String)
            XCTAssert(dictionary!["token"] as! String == "another_secure_token")
        } catch let error {
            print(error.localizedDescription)
            XCTFail()
        }
    }
    
    func testGetAuthenticated() {
        let username = "secret_username"
        let token = "secret_token"
        
        do {
            try Locksmith.saveData(data: ["username": username, "token": token], forUserAccount: "current")
            XCTAssert(sut.isUserAuthenticated() == true)
            try Locksmith.deleteDataForUserAccount(userAccount: "current", inService: "com.mezuka.Mezuka")
            XCTAssert(sut.isUserAuthenticated() == false)
        } catch {
            print(error.localizedDescription)
            XCTFail()
        }
    }
}
