//
//  UpdateCoachingDetailsApiDataManager.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import SwiftyJSON

final class UpdateCoachingDetailsApiDataManager: UpdateCoachingDetailsProtocol {
    init() {}
    
    func updateCoachingDetails(data: UpdateCoachingDetailsInputDomainModel,  callback: @escaping (ECallbackResultType) -> Void) {
        do {
            let api: ApiServiceProtocol = ApiService()
            let url: String = try api.constructApiEndpoint(base: "http://114.143.177.218/expert_connect", params: "update_coaching_details.php")
            let headers = try api.constructHeader(withCsrfToken: true, cookieDictionary: nil)
            
            var parameters = ["usertype" : data.userType as AnyObject] as [String: AnyObject]
            parameters["user_id"] = data.userId as AnyObject?
            parameters["coaching_venue"] = data.coachingVenue as AnyObject?
            let apiConverter = UpdateCoachingDetailsApiModelConverter()
            api.create(url,
                       parameters: parameters as [String : AnyObject]?,
                       headers: headers,
                       converter: { (json) -> AnyObject in
                                        return apiConverter.fromUpdateJson(json: json) as UpdateCoachingDetailsOutputDomainModel},
                       callback: callback)
            
        } catch {
            // Change it with the real error
            callback(.Failure(.UnknownError))
        }
    }
    
    func getCoachingDetails(data: UpdateCoachingDetailsInputDomainModel,  callback: @escaping (ECallbackResultType) -> Void) {
        do {
            let api: ApiServiceProtocol = ApiService()
            let url: String = try api.constructApiEndpoint(base: "http://114.143.177.218/expert_connect", params: "get_coaching_details.php")
            let headers = try api.constructHeader(withCsrfToken: true, cookieDictionary: nil)
            
            var parameters = ["usertype" : data.userType as AnyObject] as [String: AnyObject]
            parameters["user_id"] = data.userId as AnyObject?
            let apiConverter = UpdateCoachingDetailsApiModelConverter()
            api.create(url,
                       parameters: parameters as [String : AnyObject]?,
                       headers: headers,
                       converter: { (json) -> AnyObject in
                        return apiConverter.fromJson(json: json) as UpdateCoachingDetailsOutputDomainModel},
                       callback: callback)
            
        } catch {
            // Change it with the real error
            callback(.Failure(.UnknownError))
        }
    }

}
