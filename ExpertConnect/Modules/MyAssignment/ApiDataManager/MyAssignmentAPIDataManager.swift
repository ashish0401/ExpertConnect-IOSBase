//
//  BrowseEnquiryReceivedNotificationAPIDataManager.swift
//  ExpertConnect
//
//  Created by Redbytes on 21/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import SwiftyJSON

final class MyAssignmentAPIDataManager: MyAssignmentProtocols {
    init() {}
    
    func getMyAssignmentDetails(model: MyAssignmentDomainModel, callback: @escaping (ECallbackResultType) -> Void) {
        do {
            let api: ApiServiceProtocol = ApiService() 
            let url: String = try api.constructApiEndpoint(base: "http://182.72.44.11/expert_connect", params: "my_assignment_list.php")
            let headers = try api.constructHeader(withCsrfToken: true, cookieDictionary: nil)
            //let model = model.toJSON()
            let parameters = ["user_id" : model.userId as AnyObject] as [String: AnyObject]
            
            let apiConverter = MyAssignmentApiModelConverter()
            
            //api.create(url: url, parameters: model, headers: headers, callback: callback)
            api.create(url,
                       parameters: parameters as [String : AnyObject]?,
                       headers: headers, converter: { (json) -> AnyObject in
                        return apiConverter.fromJson(json: json) as MyAssignmentOutputDomainModel},
                       callback: callback)
        } catch {
            // Change it with the real error
            callback(.Failure(.UnknownError))
        }
    }
}
