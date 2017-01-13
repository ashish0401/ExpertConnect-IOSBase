//
//  ApiService.swift
//  Mezuka
//
//  Created by Hasan H. Topcu on 21/09/2016.
//  Copyright © 2016 Mezuka. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ApiService: ApiServiceProtocol {
    private let cookieKey = "cookieKey"
    private let csrfTokenKey = "csrf-token"
    private let mezukaLocationCookieKey = "mezuka_current_location"
    
    /**
     This function constructs an api endpoint with the given parameters
     - parameters:
     - base: Base url
     - params: url segments for endpoint construction
     - returns: API Endpoint
     */
    func constructApiEndpoint(base: String, params: String...) throws -> String {
        var url: String = base.hasSuffix("/") ? base.substring(to: base.index(before: base.endIndex)) : base
        
        for param in params {
            guard !param.isEmpty else {
                throw EApiErrorType.InvalidParameters
            }
            
            let trimmed = param.trimmingCharacters(in: .whitespacesAndNewlines)
            let pure = trimmed.replacingOccurrences(of: "/", with: "")
            
            url = "\(url)/\(pure)"
        }
        
        return url
    }
    
    /**
     This method constructs HTTP header to consume the API
     - parameters:
     - csrfToken: CSRF Token for passing CSRF
     - returns: HTTP header as key-value pairs
     */
    func constructHeader(withCsrfToken exist: Bool, cookieDictionary: [String: String]?) throws -> [String: String] {
        let headers = [
            "Content-Type": "application/json; charset=utf-8",
            "Accept-Encoding": "gzip, deflate, sdch, br"
        ] // Expect JSON from API
        
        
        // Update cookie if new key-values exist
        /*    let cookie = self.getCookieString()
         if var cookie = cookie {
         if(cookieDictionary != nil && cookieDictionary!.count > 0) {
         for keyValuePair in cookieDictionary! {
         cookie = self.updateCookieString(cookie: cookie, withKey: keyValuePair.key, withValue: keyValuePair.value)
         }
         }
         
         headers["Cookie"] = cookie // Send the current cookie at every request
         }
         
         if (exist) {
         let csrfToken = self.getCsrfToken()
         
         if csrfToken == nil {
         throw EApiErrorType.InvalidCsrfToken
         }
         
         headers["X-CSRF-TOKEN"] = csrfToken!
         }
         */
        return headers
    }
    
    /**
     This method sends a GET request to given url in order to fetch data
     - parameters:
     - url: API Endpoint
     - headers: Required HTTP header
     - callback: The callback handler to provide the result of the fetched data
     */
    func get(url: String, headers: [String : String]?, converter: ((JSON) -> Any)?, callback: @escaping (ECallbackResultType) -> Void) {
        // Send the GET request
        Alamofire.request(url, method: .get, headers: headers).responseJSON { response in
            // Get the status code of response
            if (response.response != nil) {
                let status = response.response!.statusCode;
                
                switch status {
                    
                case EHttpStatusCode.OK.rawValue:
                    // Get the response body
                    if let value = response.result.value {
                        let json = JSON(value)
                        let model = converter!(json)
                        // call callback with no error
                        callback(ECallbackResultType.Success(model))
                    } else {
                        callback(ECallbackResultType.Failure(EApiErrorType.UnknownError))
                    }
                    
                default:
                    callback(ECallbackResultType.Failure(EApiErrorType.UnknownError))
                }
            } else {
                callback(ECallbackResultType.Failure(EApiErrorType.APIEndpointNotAvailable))
            }
        }
    }
    
    func getCookies(url: String, headers: [String : String]?) {
        // Send the GET request
        Alamofire.request(url, method: .get, headers: headers).responseJSON { response in
            if(response.response != nil) {
                let cookieString = response.response?.allHeaderFields["Set-Cookie"] as! String
                print("COOKIE STRING: \(cookieString)")
                self.setCookieString(cookie: cookieString)
                
                let token = self.parseCsrfTokenFrom(cookieString: cookieString)
                print("PARSED XSRF TOKEN: \(token)")
                
                // Save csrf token to be used in each request
                self.setCsrfToken(token: token)
            }
        }
    }
    
    func create(_ url: String, parameters: [String : Any]?, headers: [String : String]?, converter: ((JSON) -> Any)?, callback: @escaping (ECallbackResultType) -> Void) {
        
        // Send the POST request
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.prettyPrinted, headers: headers)
            .responseJSON { response in
                
                if (response.response != nil) {
                    
                    if let value = response.result.value as Any? {
                        
                        var model: Any? = nil
                        
                        if converter != nil {
                            let json = JSON(value)
                            
                            if json["status"].boolValue {
                                model = converter!(json)
                                // call callback with no error
                                callback(ECallbackResultType.Success(model))
                            } else {
                                callback(ECallbackResultType.Failure(EApiErrorType.UnknownError))
                            }
                        }
                    } else {
                        callback(ECallbackResultType.Failure(EApiErrorType.UnknownError))
                    }

                    
                    /*
                     // Get the status code of response
                     let status = response.response!.statusCode;
                     
                     switch status {
                     
                     case EHttpStatusCode.CREATED.rawValue:
                     // Get the response body
                     if let value = response.result.value as Any? {
                     
                     var model: Any? = nil
                     
                     if converter != nil {
                     let json = JSON(value)
                     model = converter!(json)
                     }
                     
                     // call callback with no error
                     callback(ECallbackResultType.Success(model))
                     }
                     
                     case EHttpStatusCode.INVALID_CREDENTIAL.rawValue:
                     // User already exist
                     callback(ECallbackResultType.Failure(EApiErrorType.InvalidCredentials))
                     
                     case EHttpStatusCode.CONFLICT.rawValue:
                     // User already exist
                     callback(ECallbackResultType.Failure(EApiErrorType.AlreadyExist))
                     
                     case EHttpStatusCode.NOT_FOUND.rawValue:
                     // The email does not exist
                     callback(ECallbackResultType.Failure(EApiErrorType.NotExist))
                     
                     case EHttpStatusCode.BAD_REQUEST.rawValue:
                     // Invalid parameters
                     callback(ECallbackResultType.Failure(EApiErrorType.InvalidParameters))
                     
                     default:
                     callback(ECallbackResultType.Failure(EApiErrorType.UnknownError))
                     } */
                } else {
                    callback(ECallbackResultType.Failure(EApiErrorType.APIEndpointNotAvailable))
                }
        }
    }
    
    func createForgotPassword(_ url: String, parameters: [String : Any]?, headers: [String : String]?, converter: ((JSON) -> Any)?, callback: @escaping (ECallbackResultType) -> Void) {
        // Send the POST request
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.prettyPrinted, headers: headers)
            .responseJSON { response in
                
                if (response.response != nil) {
                    
                    if let value = response.result.value as Any? {
                        
                        var model: Any? = nil
                        
                        if converter != nil {
                            let json = JSON(value)
                            
                            if json["status"].boolValue {
                                model = converter!(json)
                                // call callback with no error
                                callback(ECallbackResultType.Success(model))
                            } else {
                                model = converter!(json)
                                callback(ECallbackResultType.Success(model))
                            }
                        }
                        
                    }else {
                        callback(ECallbackResultType.Failure(EApiErrorType.UnknownError))
                    }
                } else {
                    callback(ECallbackResultType.Failure(EApiErrorType.UnknownError))
                }
        }
    }
    /**
     This method sends a PUT request to given url in order to update data
     - parameters:
     - url: API endpoint
     - parameters: The data to be updated
     - headers: Required HTTP header
     - callback: The callback handler to provide the result of the update operation
     */
    func update(url: String, parameters: [String : Any]?, headers: [String : String]?, callback: @escaping (ECallbackResultType) -> Void) {
        // Send the POST request
        Alamofire.request(url, method: .put, parameters: parameters!, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                
                print("PUT REQUEST")
                print(NSString(data: (response.request?.httpBody)!, encoding: String.Encoding.utf8.rawValue)!)
                print(response.request?.allHTTPHeaderFields)
                
                if (response.response != nil) {
                    // Get the status code of response
                    let status = response.response!.statusCode;
                    
                    print(String(data: response.data!, encoding: String.Encoding.utf8))
                    
                    switch status {
                        
                    case EHttpStatusCode.OK.rawValue:
                        // Successful - No error
                        callback(ECallbackResultType.Success(nil))
                        
                    case EHttpStatusCode.INVALID_CREDENTIAL.rawValue:
                        // invalid credentials
                        callback(ECallbackResultType.Failure(EApiErrorType.InvalidCredentials))
                        
                    case EHttpStatusCode.CONFLICT.rawValue:
                        // Resource already exist
                        callback(ECallbackResultType.Failure(EApiErrorType.AlreadyExist))
                        
                    case EHttpStatusCode.NOT_FOUND.rawValue:
                        // The resource does not exist
                        callback(ECallbackResultType.Failure(EApiErrorType.NotExist))
                        
                    case EHttpStatusCode.BAD_REQUEST.rawValue:
                        // Invalid parameters
                        callback(ECallbackResultType.Failure(EApiErrorType.InvalidParameters))
                        
                    default:
                        callback(ECallbackResultType.Failure(EApiErrorType.UnknownError))
                    }
                } else {
                    callback(ECallbackResultType.Failure(EApiErrorType.APIEndpointNotAvailable))
                }
        }
    }
    
    /**
     This method sends a DELETE request to given url in order to update data
     - parameters:
     - url: API endpoint
     - parameters: The data to be updated
     - headers: Required HTTP header
     - callback: The callback handler to provide the result of the update operation
     */
    func delete(url: String, parameters: [String : Any]?, headers: [String : String]?, callback: @escaping (ECallbackResultType) -> Void) {
        // Send the POST request
        Alamofire.request(url, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                
                if (response.response != nil) {
                    // Get the status code of response
                    let status = response.response!.statusCode;
                    
                    switch status {
                        
                    case EHttpStatusCode.OK.rawValue:
                        // Deletion Successful - No error
                        callback(ECallbackResultType.Success(nil))
                        
                    case EHttpStatusCode.INVALID_CREDENTIAL.rawValue:
                        // invalid credentials
                        callback(ECallbackResultType.Failure(EApiErrorType.InvalidCredentials))
                        
                    case EHttpStatusCode.NOT_FOUND.rawValue:
                        // The resource does not exist
                        callback(ECallbackResultType.Failure(EApiErrorType.NotExist))
                        
                    case EHttpStatusCode.BAD_REQUEST.rawValue:
                        // Invalid parameters
                        callback(ECallbackResultType.Failure(EApiErrorType.InvalidParameters))
                        
                    default:
                        callback(ECallbackResultType.Failure(EApiErrorType.UnknownError))
                    }
                } else {
                    callback(ECallbackResultType.Failure(EApiErrorType.APIEndpointNotAvailable))
                }
        }
    }
    
    func setCookieString(cookie:String) {
        UserDefaults.standard.removeObject(forKey: self.cookieKey)
        UserDefaults.standard.setValue(cookie, forKey: self.cookieKey)
        UserDefaults.standard.synchronize()
    }
    
    func getCookieString() -> String? {
        let cookie = UserDefaults.standard.object(forKey: self.cookieKey) as? String
        return cookie
    }
    
    func updateCookieString(cookie: String, withKey key: String, withValue value: String) -> String {
        var newCookie = String(cookie)!
        
        if(newCookie.contains(key) == false) {
            newCookie = "\(key)=\(value); \(cookie)" // Add the key/value at the beginning of the cookie
        } else {
            // TODO: Should be more readable
            let start = cookie.range(of: "\(key)=")
            let startStr = cookie.substring(from: (start?.upperBound)!)
            let previousStr = cookie.substring(to: (start?.upperBound)!)
            let previousLength = previousStr.characters.count
            let chars = startStr.characters
            let index = chars.index(of: ";")
            let existingValueStr = startStr.substring(to: index!)
            let length = existingValueStr.characters.count
            
            let rangeToBeReplaced = Range(uncheckedBounds: (lower: (start?.upperBound)!, upper: cookie.index(cookie.startIndex, offsetBy: previousLength + length)))
            newCookie.replaceSubrange(rangeToBeReplaced, with: value)
        }
        
        //"mezuka_current_location=\(ConfigurationService.getCurrentLocation()); \(headers["Cookie"]!)"
        return newCookie
    }
    
    func setCsrfToken(token: String) {
        UserDefaults.standard.set(token, forKey: self.csrfTokenKey)
        UserDefaults.standard.synchronize()
    }
    
    func getCsrfToken() -> String? {
        let csrfToken = UserDefaults.standard.string(forKey: self.csrfTokenKey)
        return csrfToken
    }
    
    /**
     XSRF-TOKEN=DkJtKJe74%2FuevTLGyUxqAp7PvUTH82BDqrRikcZ5GH85gzDKZIxdl%2B0zs3yFr2ybWfVt7So8XrwTREgkJvluig%3D%3D; path=/; secure, _mezuka_session=b3JQbFhxWnoxS2VRT2JtWEQyNWZkNnMyZjV5MVBYbFAxWTJYNTRWZTBlekpiQmE1MVVmL0N1eHg2S2loUWtOM3dtNEVRSW5leEZ3RHZnWUxySnlNa05wVmM2NlYyRHdFTldmQlJKdnBlQzdGQ2U5SmtZM002bVY4SmdXbVVnWWhPRWQ5TzNBMGtmZVlNUThSQmJScTBRPT0tLVlXNFczekw5SGM0UEhjQUpoZGhpVnc9PQ%3D%3D--9bc3f489cd2ec5dc9af13e0421b9d8b4dbf8587e; path=/; secure; HttpOnly
     
     */
    private func parseCsrfTokenFrom(cookieString: String) -> String {
        if cookieString.isEmpty == false {
            let start = cookieString.range(of: "XSRF-TOKEN=")
            let startStr = cookieString.substring(from: (start?.upperBound)!)
            let end = startStr.range(of: ";")
            let token = startStr.substring(to: (end?.lowerBound)!)
            
            // remove url encoded percentages %3D -> =
            return token.removingPercentEncoding!
        }
        
        return ""
    }
}
