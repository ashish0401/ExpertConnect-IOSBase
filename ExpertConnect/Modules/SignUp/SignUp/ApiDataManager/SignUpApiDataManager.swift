//
//  SignUpApiDataManager.swift
//  ExpertConnect
//
//  Created by Nadeem on 23/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import SwiftyJSON

final class SignUpApiDataManager: SignUpProtocols {
    init() {}
    
    func signUp(data:SignUpInputDomainModel,  callback: @escaping (ECallbackResultType) -> Void) {
        do {
            let api: ApiServiceProtocol = ApiService()
            let url: String = try api.constructApiEndpoint(base: "http://114.143.177.218/expert_connect", params: "register.php")
            let headers = try api.constructHeader(withCsrfToken: true, cookieDictionary: nil)

            let parameters = ["usertype" : data.userType, "firstname" : data.firstName, "lastname" : data.lastName, "email_id" : data.emailId, "password" : data.password, "country_code" : data.countryCode, "mobile_no" : data.mobileNo, "dob" : data.dob, "gender" : data.gender, "profile_pic" : data.profilePic, "device_token" : data.deviceToken, "os_type" : data.osType, "latitude" : data.latitude, "longitude" : data.longitude, "location" : data.location, "reg_type" : data.regType, "social_id" : data.socialId ] as [String : Any]

            let apiConverter = SignUpApiModelConverter()
            api.createForgotPassword(url,
                       parameters: parameters as [String : AnyObject]?,
                       headers: headers, converter: { (json) -> AnyObject in
                        return apiConverter.fromJson(json: json) as SignUpOutputDomainModel},
                       callback: callback)
            
        } catch {
            // Change it with the real error
            callback(.Failure(.UnknownError))
        }
    }
}
