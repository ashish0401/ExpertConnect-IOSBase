//
//  BrowseEnquirySentNotificationAPIDataManager.swift
//  ExpertConnect
//
//  Created by Redbytes on 21/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import SwiftyJSON

final class BrowseEnquirySentNotificationAPIDataManager: BrowseEnquirySentNotificationProtocols {
    init() {}
    
    func getBrowseEnquirySentNotificationDetails(model: BrowseEnquirySentNotificationDomainModel, callback: @escaping (ECallbackResultType) -> Void) {
        do {
            let api: ApiServiceProtocol = ApiService() 
            let url: String = try api.constructApiEndpoint(base: "http://114.143.177.218/expert_connect", params: "my_sent_notification.php")
            let headers = try api.constructHeader(withCsrfToken: true, cookieDictionary: nil)
            let parameters = ["user_id" : model.userId as AnyObject] as [String: AnyObject]
            
            let apiConverter = BrowseEnquirySentNotificationApiModelConverter()
            
            api.create(url,
                       parameters: parameters as [String : AnyObject]?,
                       headers: headers, converter: { (json) -> AnyObject in
                        return apiConverter.fromJson(json: json) as BrowseEnquirySentNotificationOutputDomainModel},
                       callback: callback)
        } catch {
            // Change it with the real error
            callback(.Failure(.UnknownError))
        }
    }
}
