//
//  MessagesViewApiDataManager.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import SwiftyJSON

final class MessagesViewApiDataManager: MessagesViewProtocol {
    init() {}
    
    func getNotificationList(data: MessagesViewInputDomainModel,  callback: @escaping (ECallbackResultType) -> Void) {
        do {
            let api: ApiServiceProtocol = ApiService()
            let url: String = try api.constructApiEndpoint(base: "http://114.143.177.218/expert_connect", params: data.urlEndPoint)
            let headers = try api.constructHeader(withCsrfToken: true, cookieDictionary: nil)
            let parameters = ["user_id" : data.userId, "command" : data.command] as [String : Any]
            
            let apiConverter = MessagesViewApiModelConverter()
            api.createForgotPassword(url,
                                     parameters: parameters as [String : AnyObject]?,
                                     headers: headers, converter: { (json) -> AnyObject? in
                                        if data.command == "getGeneralEnquiryList" {
                                            return apiConverter.fromJson(json: json) as EnquiryViewOutputDomainModel
  
                                        } else if data.command == "getNotificationList" {
                                            return apiConverter.fromJson(json: json) as MessagesViewOutputDomainModel
                                        }
                                        return nil
                                        },
                                     callback: callback)
            
        } catch {
            // Change it with the real error
            callback(.Failure(.UnknownError))
        }
    }
    
    func sendEnquiry(data: SendEnquiryInputModel,  callback: @escaping (ECallbackResultType) -> Void) {
        do {
            let api: ApiServiceProtocol = ApiService()
            let url: String = try api.constructApiEndpoint(base: "http://114.143.177.218/expert_connect", params: "general_enquiries.php")
            let headers = try api.constructHeader(withCsrfToken: true, cookieDictionary: nil)
            
            var parameters = ["command" : data.command as AnyObject] as [String: AnyObject]
            parameters["user_id"] = data.userId as String? as AnyObject?
            parameters["message"] = data.message as String? as AnyObject?
            
            let apiConverter = MessagesViewApiModelConverter()
            api.createForgotPassword(url,
                                     parameters: parameters as [String : AnyObject]?,
                                     headers: headers, converter: { (json) -> AnyObject in
                                        return apiConverter.fromJson(json: json) as OTPOutputDomainModel},
                                     callback: callback)
            
        } catch {
            // Change it with the real error
            callback(.Failure(.UnknownError))
        }
    }
}
