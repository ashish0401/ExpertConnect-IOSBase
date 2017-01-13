//
//  BrowseExpertListApiDataManager.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import SwiftyJSON

final class BrowseExpertListApiDataManager: BrowseExpertListProtocols {
    
    init() {}
    
    func getBrowseExpertList(data:BrowseExpertListDomainModel,  callback: @escaping (ECallbackResultType) -> Void) {
        do {
            let api: ApiServiceProtocol = ApiService()
            let url: String = try api.constructApiEndpoint(base: "http://182.72.44.11/expert_connect", params: "expert_teacher_list.php")
            let headers = try api.constructHeader(withCsrfToken: true, cookieDictionary: nil)
            let parameters = ["user_id" : data.userId, "location" : data.location, "offset" : data.offset, "limit" : data.limit] as [String : Any]
            
            let apiConverter = BrowseExpertListApiModelConverter()
            api.createForgotPassword(url,
                                     parameters: parameters as [String : AnyObject]?,
                                     headers: headers, converter: { (json) -> AnyObject in
                                        return apiConverter.fromJson(json: json) as BrowseExpertListOutputDomainModel},
                                     callback: callback)
            
        } catch {
            // Change it with the real error
            callback(.Failure(.UnknownError))
        }
    }
}
