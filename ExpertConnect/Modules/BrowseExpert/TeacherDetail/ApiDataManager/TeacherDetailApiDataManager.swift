//
//  BrowseExpertListApiDataManager.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import SwiftyJSON

final class TeacherDetailApiDataManager: TeacherDetailProtocols {
    
    init() {}
    
    func addReview(data: TeacherRatingInputDomainModel,  callback: @escaping (ECallbackResultType) -> Void) {
        do {
            let api: ApiServiceProtocol = ApiService()
            let url: String = try api.constructApiEndpoint(base: "http://114.143.177.218/expert_connect", params: "rateTeacher.php")
            let headers = try api.constructHeader(withCsrfToken: true, cookieDictionary: nil)
            let parameters = ["ratedBy" : data.ratedBy, "user_id" : data.teacherId, "expert_id" : data.expertId, "rate" : data.rating] as [String : Any]
            
            let apiConverter = BlogDetailViewApiModelConverter()
            api.createForgotPassword(url,
                                     parameters: parameters as [String : AnyObject]?,
                                     headers: headers, converter: { (json) -> AnyObject in
                                        return apiConverter.fromResetPasswordJson(json: json) as OTPOutputDomainModel},
                                     callback: callback)
            
        } catch {
            // Change it with the real error
            callback(.Failure(.UnknownError))
        }
    }
}
