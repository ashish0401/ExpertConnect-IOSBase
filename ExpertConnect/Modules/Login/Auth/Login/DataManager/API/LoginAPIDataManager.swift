//
// Created by hhtopcu.
// Copyright (c) 2016 hhtopcu. All rights reserved.
//

import Foundation
import SwiftyJSON

final class LoginAPIDataManager: LoginAPIDataManagerInputProtocol {
    init() {}
    
   // http://182.72.44.11/expert_connect/login.php
    
    func authenticateUser(model: LoginDomainModel, callback: @escaping (ECallbackResultType) -> Void) {
        do {
            let api: ApiServiceProtocol = ApiService()
            let url: String = try api.constructApiEndpoint(base: "http://182.72.44.11/expert_connect", params: "login.php")
            let headers = try api.constructHeader(withCsrfToken: true, cookieDictionary: nil)
            //let model = model.toJSON()
            let parameters = ["email_id": model.email, "password": model.password, "device_token": model.deviceToken, "os_type":model.operatingSysType] as [String : Any]

            let apiConverter = LoginApiModelConverter()
            
            //api.create(url: url, parameters: model, headers: headers, callback: callback)
            api.create(url,
                       parameters: parameters as [String : AnyObject]?,
                       headers: headers, converter: { (json) -> AnyObject in
                            return apiConverter.fromJson(json: json) as LoginOutputDomainModel},
                       callback: callback)
            
        } catch {
            // Change it with the real error
            callback(.Failure(.UnknownError))
        }
    }

    func authenticateUserWithFacebook(model: LoginWithFacebookDomainModel, callback: @escaping (ECallbackResultType) -> Void) {
        do {
            let api: ApiServiceProtocol = ApiService()
            let url: String = try api.constructApiEndpoint(base: "http://182.72.44.11/expert_connect", params: "fb_login.php")
            let headers = try api.constructHeader(withCsrfToken: true, cookieDictionary: nil)
            //let model = model.toJSON()
            let parameters = ["reg_type": model.regType, "social_id": model.socialId, "device_token": model.deviceToken, "os_type":model.operatingSysType] as [String : Any]
            
            let apiConverter = LoginApiModelConverter()
            
            //api.create(url: url, parameters: model, headers: headers, callback: callback)
            api.create(url,
                       parameters: parameters as [String : AnyObject]?,
                       headers: headers, converter: { (json) -> AnyObject in
                        return apiConverter.fromJson(json: json) as LoginOutputDomainModel},
                       callback: callback)
            
        } catch {
            // Change it with the real error
            callback(.Failure(.UnknownError))
        }

    }

    func forgotPassword(model: FPDomainModel, callback: @escaping (ECallbackResultType) -> Void) {
        do {
            let api: ApiServiceProtocol = ApiService()
            let url: String = try api.constructApiEndpoint(base: "http://182.72.44.11/expert_connect", params: "forget_password.php")
            let headers = try api.constructHeader(withCsrfToken: true, cookieDictionary: nil)
            //let model = model.toJSON()
            let parameters = ["email_id": model.email] as [String : Any]
            
            let apiConverter = FPApiModelConverter()
            
            //api.create(url: url, parameters: model, headers: headers, callback: callback)
            api.createForgotPassword(url,
                                     parameters: parameters as [String : AnyObject]?,
                                     headers: headers, converter: { (json) -> AnyObject in
                                        return apiConverter.fromJson(json: json) as FPOutputDomainModel},
                                     callback: callback)
            
        } catch {
            // Change it with the real error
            callback(.Failure(.UnknownError))
        }
    }
}
