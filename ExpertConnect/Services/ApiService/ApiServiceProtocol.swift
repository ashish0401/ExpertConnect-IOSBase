//
//  ApiServiceProtocol.swift
//  Mezuka
//
//  Created by Hasan H. Topcu on 21/09/2016.
//  Copyright © 2016 Mezuka. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol ApiServiceProtocol {
    func constructApiEndpoint(base: String, params: String...) throws -> String
    
    func constructHeader(withCsrfToken exist: Bool, cookieDictionary: [String: String]?) throws -> [String: String]
    
    func getCookies(url: String, headers: [String : String]?)
    
    func updateCookieString(cookie: String, withKey key: String, withValue value: String) -> String
    
    func get(url: String,
             headers: [String : String]?,
             converter: ((JSON) -> Any)?,
             callback: @escaping (ECallbackResultType) -> Void)
    
    func update(url: String,
                parameters: [String : Any]?,
                headers: [String : String]?,
                callback: @escaping (ECallbackResultType) -> Void)
    
    func create(_ url: String,
                parameters: [String : Any]?,
                headers: [String : String]?,
                converter: ((JSON) -> Any)?,
                callback: @escaping (ECallbackResultType) -> Void)
    
    func createForgotPassword(_ url: String,
                              parameters: [String : Any]?,
                              headers: [String : String]?,
                              converter: ((JSON) -> Any)?,
                              callback: @escaping (ECallbackResultType) -> Void)
    
    func delete(url: String,
                parameters: [String : Any]?,
                headers: [String : String]?,
                callback: @escaping (ECallbackResultType) -> Void)
}
