//
//  verifyEmailAndMobileNoApiDataManager.swift
//  ExpertConnect
//
//  Created by Nadeem on 23/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import SwiftyJSON

final class verifyEmailAndMobileNoApiDataManager: verifyEmailAndMobileNoProtocols {
    init() {}
    
    func verifyEmailAndMobileNo(data:verifyEmailAndMobileNoInputDomainModel,  callback: @escaping (ECallbackResultType) -> Void) {
        do {
            let api: ApiServiceProtocol = ApiService()
            let url: String = try api.constructApiEndpoint(base: "http://182.72.44.11/expert_connect", params: "verify_email_mobile.php")
            let headers = try api.constructHeader(withCsrfToken: true, cookieDictionary: nil)

            let parameters = ["email_id" : data.emailId, "mobile_no" : data.mobileNo] as [String : Any]

            let apiConverter = verifyEmailAndMobileNoApiModelConverter()
            api.createForgotPassword(url,
                       parameters: parameters as [String : AnyObject]?,
                       headers: headers, converter: { (json) -> AnyObject in
                        return apiConverter.fromJson(json: json) as verifyEmailAndMobileNoOutputDomainModel},
                       callback: callback)
            
        } catch {
            // Change it with the real error
            callback(.Failure(.UnknownError))
        }
    }
}
