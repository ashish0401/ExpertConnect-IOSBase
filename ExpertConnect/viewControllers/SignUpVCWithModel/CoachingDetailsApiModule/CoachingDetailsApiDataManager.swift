//
//  CoachingDetailsApiDataManager.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import SwiftyJSON

final class CoachingDetailsApiDataManager: CoachingDetailsProtocol {
    init() {}
    
    func coachingDetails(endpoint: String, data: CoachingDetailsInputDomainModel,  callback: @escaping (ECallbackResultType) -> Void) {
        do {
            let api: ApiServiceProtocol = ApiService()
            let url: String = try api.constructApiEndpoint(base: "http://182.72.44.11/expert_connect", params: endpoint)
            let headers = try api.constructHeader(withCsrfToken: true, cookieDictionary: nil)
            
            let parameters = ["user_id" : data.userId, "coaching_venue" : data.coachingVenue] as [String : Any]
            
            let apiConverter = CoachingDetailsApiModelConverter()
            api.createForgotPassword(url,
                                     parameters: parameters as [String : AnyObject]?,
                                     headers: headers, converter: { (json) -> AnyObject in
                                        return apiConverter.fromJson(json: json) as CoachingDetailsOutputDomainModel},
                                     callback: callback)
            
        } catch {
            // Change it with the real error
            callback(.Failure(.UnknownError))
        }
    }
}
