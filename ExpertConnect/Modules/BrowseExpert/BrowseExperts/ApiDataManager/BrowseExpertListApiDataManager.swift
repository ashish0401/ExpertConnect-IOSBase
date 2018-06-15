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
            let url: String = try api.constructApiEndpoint(base: "http://114.143.177.218/expert_connect", params: "expert_teacher_list.php")
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
    
    func sendMessage(data: SendMessageInputModel,  callback: @escaping (ECallbackResultType) -> Void) {
        do {
            let api: ApiServiceProtocol = ApiService()
            let url: String = try api.constructApiEndpoint(base: "http://114.143.177.218/expert_connect", params: "notification_activity.php")
            let headers = try api.constructHeader(withCsrfToken: true, cookieDictionary: nil)
            
            var parameters = ["command" : data.command as AnyObject] as [String: AnyObject]
            parameters["sender"] = data.senderId as String? as AnyObject?
            parameters["receiver"] = data.receiverId as String? as AnyObject?
            parameters["message"] = data.message as String? as AnyObject?
            parameters["type"] = data.notificationType as String? as AnyObject?
            
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
