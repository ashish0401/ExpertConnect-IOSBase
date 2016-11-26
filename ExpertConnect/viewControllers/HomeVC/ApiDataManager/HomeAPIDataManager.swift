//
//  HomeAPIDataManager.swift
//  ExpertConnect
//
//  Created by Redbytes on 21/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import SwiftyJSON

final class HomeAPIDataManager: HomeProtocols {
    init() {}
    
    func getCategoryDetails(callback: @escaping (ECallbackResultType) -> Void) {
        do {
            let api: ApiServiceProtocol = ApiService()
            let url: String = try api.constructApiEndpoint(base: "http://182.72.44.11/expert_connect", params: "get_categories.php")
            let headers = try api.constructHeader(withCsrfToken: true, cookieDictionary: nil)
            //let model = model.toJSON()
            let parameters = [:] as [String : Any]
            
            let apiConverter = HomeApiModelConverter()
            
            //api.create(url: url, parameters: model, headers: headers, callback: callback)
            api.create(url,
                       parameters: parameters as [String : AnyObject]?,
                       headers: headers, converter: { (json) -> AnyObject in
                        return apiConverter.fromJson(json: json) as HomeOutputDomainModel},
                       callback: callback)
        } catch {
            // Change it with the real error
            callback(.Failure(.UnknownError))
        }

    }
  
}
