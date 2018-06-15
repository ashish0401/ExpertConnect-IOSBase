//
//  UpdateProfileViewApiDataManager.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import SwiftyJSON

final class UpdateProfileViewApiDataManager: UpdateProfileViewProtocol {
    init() {}
    
    func updateProfile(data: UpdateProfileViewInputDomainModel,  callback: @escaping (ECallbackResultType) -> Void) {
        do {
            let api: ApiServiceProtocol = ApiService()
            let url: String = try api.constructApiEndpoint(base: "http://114.143.177.218/expert_connect", params: "edit_profile.php")
            let headers = try api.constructHeader(withCsrfToken: true, cookieDictionary: nil)
            let parameters = ["user_id" : data.userId,
                              "usertype" : data.userType,
                              "firstname" : data.firstName,
                              "lastname" : data.lastName,
                              "email_id" : data.emailId,
                              "dob" : data.dob,
                              "profile_pic" : data.profilePic,
                              "latitude" : data.latitude,
                              "longitude" : data.longitude,
                              "location" : data.location] as [String : Any]
            
            let apiConverter = UpdateProfileViewApiModelConverter()
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
