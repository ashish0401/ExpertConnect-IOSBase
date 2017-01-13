//
//  ApiDataManager.swift
//  ExpertConnect
//
//  Created by Nadeem on 23/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import SwiftyJSON

final class FPApiDataManager: FPProtocols {
    init() {}
    
    func getStatusAndMessage(callback: @escaping (ECallbackResultType) -> Void) {
        do {
            let api: ApiServiceProtocol = ApiService()
            let url: String = try api.constructApiEndpoint(base: "http://182.72.44.11/expert_connect", params: "forget_password.php")
            let headers = try api.constructHeader(withCsrfToken: true, cookieDictionary: nil)
            
            let parameters = ["email_id":"bhushan@gmail.com"] as [String : Any]
            
            let apiConverter = FPApiModelConverter()
            
            //api.create(url: url, parameters: model, headers: headers, callback: callback)
            api.create(url,
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
