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
            
            let parameters = ["user_id" : data.userId, "category_id" : data.categoryId, "sub_category_id" : data.subCategoryId, "qualification" : data.qualification, "about" : data.about, "beginner" : data.beginner, "intermediate" : data.intermediate, "advance" : data.advance] as [String : Any]
            
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
