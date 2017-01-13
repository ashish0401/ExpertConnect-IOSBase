//
//  BrowseEnquiryReceivedNotificationAPIDataManager.swift
//  ExpertConnect
//
//  Created by Redbytes on 21/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import SwiftyJSON

final class BrowseEnquiryReceivedNotificationAPIDataManager: BrowseEnquiryReceivedNotificationProtocols {
    init() {}
    
    func getBrowseEnquiryReceivedNotificationDetails(model: BrowseEnquiryReceivedNotificationDomainModel, callback: @escaping (ECallbackResultType) -> Void) {
        do {
            let api: ApiServiceProtocol = ApiService() 
            let url: String = try api.constructApiEndpoint(base: "http://182.72.44.11/expert_connect", params: "brows_inquiry.php")
            let headers = try api.constructHeader(withCsrfToken: true, cookieDictionary: nil)
            //let model = model.toJSON()
            var parameters = ["teacher_id" : model.userId as AnyObject] as [String: AnyObject]
            parameters["category_id"] = model.categoryId as String? as AnyObject?
            parameters["sub_category_id"] =  model.subCategoryId as String? as AnyObject?
            parameters["filter"] = model.isFilter as String? as AnyObject?
            parameters["amount"] = model.ammount as String? as AnyObject?
            
            let apiConverter = BrowseEnquiryReceivedNotificationApiModelConverter()
            
            //api.create(url: url, parameters: model, headers: headers, callback: callback)
            api.create(url,
                       parameters: parameters as [String : AnyObject]?,
                       headers: headers, converter: { (json) -> AnyObject in
                        return apiConverter.fromJson(json: json) as BrowseEnquiryReceivedNotificationOutputDomainModel},
                       callback: callback)
        } catch {
            // Change it with the real error
            callback(.Failure(.UnknownError))
        }
    }
}
