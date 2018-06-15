//
//  TeacherFilterApiDataManager.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import SwiftyJSON

final class TeacherFilterApiDataManager: TeacherFilterProtocols {
    
    init() {}
    
    func getTeacherFilterList(data:TeacherFilterDomainModel,  callback: @escaping (ECallbackResultType) -> Void) {
        do {
            let api: ApiServiceProtocol = ApiService()
            let url: String = try api.constructApiEndpoint(base: "http://114.143.177.218/expert_connect", params: "teacher_filter_list")
            let headers = try api.constructHeader(withCsrfToken: true, cookieDictionary: nil)
            
            var parameters = ["user_id" : data.userId as AnyObject] as [String: AnyObject]
            parameters["category_id"] = data.categoryId as String? as AnyObject?
            parameters["sub_category_id"] = data.subCategoryId as String? as AnyObject?
            //parameters["level"] = data.level as String? as AnyObject?
            parameters["venue"] = data.coachingVenue as AnyObject?
                
            let apiConverter = TeacherFilterApiModelConverter()
            api.createForgotPassword(url,
                                     parameters: parameters as [String : AnyObject]?,
                                     headers: headers, converter: { (json) -> AnyObject in
                                        return apiConverter.fromJson(json: json) as TeacherFilterOutputDomainModel},
                                     callback: callback)
            
        } catch {
            // Change it with the real error
            callback(.Failure(.UnknownError))
        }
    }
}
