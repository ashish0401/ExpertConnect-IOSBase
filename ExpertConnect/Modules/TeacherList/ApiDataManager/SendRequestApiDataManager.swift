//
//  SendRequestApiDataManager.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import SwiftyJSON

final class SendRequestApiDataManager: SendRequestProtocols {
    
    init() {}
    
    func sendRequest(data:SendRequestDomainModel,  callback: @escaping (ECallbackResultType) -> Void) {
        do {
            let api: ApiServiceProtocol = ApiService()
            let url: String = try api.constructApiEndpoint(base: "http://182.72.44.11/expert_connect", params: "notification_request.php")
            let headers = try api.constructHeader(withCsrfToken: true, cookieDictionary: nil)
            let parameters = ["from_id" : data.fromId, "to_id" : data.toId, "type" : data.type, "expert_id" : data.expertId] as [String : Any]
           
            let apiConverter = SendRequestApiModelConverter()
            api.createForgotPassword(url,
                                     parameters: parameters as [String : AnyObject]?,
                                     headers: headers, converter: { (json) -> AnyObject in
                                        return apiConverter.fromJson(json: json) as SendRequestOutputDomainModel},
                                     callback: callback)
            
        } catch {
            // Change it with the real error
            callback(.Failure(.UnknownError))
        }
    }
    
    func sendAcceptRejectRequest(data:SendRequestDomainModel,  callback: @escaping (ECallbackResultType) -> Void) {
        do {
            let api: ApiServiceProtocol = ApiService()
            let url: String = try api.constructApiEndpoint(base: "http://182.72.44.11/expert_connect", params: "accept_reject_notification.php")
            let headers = try api.constructHeader(withCsrfToken: true, cookieDictionary: nil)
            let parameters = ["from_id" : data.fromId, "to_id" : data.toId, "type" : data.type, "expert_id" : data.expertId] as [String : Any]
            
            let apiConverter = SendRequestApiModelConverter()
            api.createForgotPassword(url,
                                     parameters: parameters as [String : AnyObject]?,
                                     headers: headers, converter: { (json) -> AnyObject in
                                        return apiConverter.fromJson(json: json) as SendRequestOutputDomainModel},
                                     callback: callback)
            
        } catch {
            // Change it with the real error
            callback(.Failure(.UnknownError))
        }
    }

}
