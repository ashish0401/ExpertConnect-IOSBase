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
    
    func coachingDetails(endpoint: String, data: RegisterUserInputDomainModel,  callback: @escaping (ECallbackResultType) -> Void) {
        do {
            let api: ApiServiceProtocol = ApiService()
            let url: String = try api.constructApiEndpoint(base: "http://182.72.44.11/expert_connect", params: endpoint)
            let headers = try api.constructHeader(withCsrfToken: true, cookieDictionary: nil)
            
            var parameters = ["usertype" : data.userType as AnyObject] as [String: AnyObject]
            parameters["firstname"] = data.firstName as String? as AnyObject?
            parameters["lastname"] =  data.lastName as String? as AnyObject?
            parameters["email_id"] = data.emailId as String? as AnyObject?
            parameters["password"] = data.password as String? as AnyObject?
            parameters["country_code"] = data.countryCode as String? as AnyObject?
            parameters["mobile_no"] = data.mobileNo as String? as AnyObject?
            parameters["dob"] = data.dob as String? as AnyObject?
            parameters["gender"] = data.gender as String? as AnyObject?
            parameters["profile_pic"] = data.profilePic as String? as AnyObject?
            parameters["device_token"] = data.deviceToken as String? as AnyObject?
            parameters["os_type"] = data.osType as String? as AnyObject?
            parameters["latitude"] = data.latitude as String? as AnyObject?
            parameters["longitude"] = data.longitude as String? as AnyObject?
            parameters["location"] = data.location as String? as AnyObject?
            parameters["reg_type"] = data.regType as String? as AnyObject?
            parameters["social_id"] = data.socialId as String? as AnyObject?
 
            if data.userType == NSString(format:"%@","3") as String {
                parameters["category_id"] = data.categoryId as String? as AnyObject?
                parameters["sub_category_id"] = data.subCategoryId as String? as AnyObject?
                parameters["qualification"] = data.qualification as String? as AnyObject?
                parameters["about"] = data.about as String? as AnyObject?
                parameters["base_price"] = data.basePrice as String? as AnyObject?
                parameters["beginner"] = data.beginner as AnyObject?
                let isIndexValidIntermediate = data.intermediate.indices.contains(2)
                if(isIndexValidIntermediate) {
                    parameters["intermediate"] = data.intermediate as AnyObject?
                }
                let isIndexValidAdvance = data.advance.indices.contains(2)
                if(isIndexValidAdvance) {
                    parameters["advance"] = data.advance as AnyObject?
                }
            }
            parameters["coaching_venue"] = data.registerCoachingVenue as AnyObject?
            let apiConverter = CoachingDetailsApiModelConverter()
            api.create(url,
                       parameters: parameters as [String : AnyObject]?,
                       headers: headers,
                       converter: { (json) -> AnyObject in
                                        return apiConverter.fromJson(json: json) as CoachingDetailsOutputDomainModel},
                       callback: callback)
            
        } catch {
            // Change it with the real error
            callback(.Failure(.UnknownError))
        }
    }
}
