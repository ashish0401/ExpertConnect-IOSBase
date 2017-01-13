//
//  ExpertDetailsApiDataManager.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import SwiftyJSON

final class ExpertDetailsApiDataManager: ExpertDetailsProtocol {
    init() {}
    
    func expertDetails(data: ExpertDetailsInputDomainModel,  callback: @escaping (ECallbackResultType) -> Void) {
        do {
            let api: ApiServiceProtocol = ApiService()
            let url: String = try api.constructApiEndpoint(base: "http://182.72.44.11/expert_connect", params: "register_expert_details.php")
            let headers = try api.constructHeader(withCsrfToken: true, cookieDictionary: nil)
            
            var parameters = ["user_id" :data.userId as String] as [String : Any]
            parameters["category_id"] = data.categoryId as String
            parameters["sub_category_id"] = data.subCategoryId as String
            parameters["qualification"] = data.qualification as String
            parameters["about"] = data.about as String
            parameters["base_price"] = data.basePrice as String
            parameters["beginner"] = data.beginner as AnyObject?
            let isIndexValidIntermediate = data.intermediate.indices.contains(2)
            if(isIndexValidIntermediate) {
                parameters["intermediate"] = data.intermediate as AnyObject?
            }
            let isIndexValidAdvance = data.advance.indices.contains(2)
            if(isIndexValidAdvance) {
                parameters["advance"] = data.advance as AnyObject?
            }
            
            let apiConverter = ExpertDetailsApiModelConverter()
            api.createForgotPassword(url,
                                     parameters: parameters as [String : AnyObject]?,
                                     headers: headers, converter: { (json) -> AnyObject in
                                        return apiConverter.fromJson(json: json) as OTPOutputDomainModel},
                                     callback: callback)
            
        } catch {
            // Change it with the real error
            callback(.Failure(.UnknownError))
        }
    }
}
