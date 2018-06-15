//
//  PromotionApiDataManager.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import SwiftyJSON

final class PromotionApiDataManager: PromotionProtocols {
    
    init() {}
    
    func getPromotionList(data:PromotionDomainModel,  callback: @escaping (ECallbackResultType) -> Void) {
        do {
            let api: ApiServiceProtocol = ApiService()
            let url: String = try api.constructApiEndpoint(base: "http://182.72.44.11/expert_connect", params: "add_promotion.php")
            let headers = try api.constructHeader(withCsrfToken: true, cookieDictionary: nil)
            var parameters = ["command" : data.command as AnyObject] as [String: AnyObject]
            if data.command == "getPromotionList" {
                parameters["user_id"] = data.userId as String? as AnyObject?
                parameters["location"] = data.location as String? as AnyObject?
                
            } else if data.command == "getMyPromotionList" {
                parameters["user_id"] = data.userId as String? as AnyObject?
            }
            
            let apiConverter = PromotionApiModelConverter()
            api.createForgotPassword(url,
                                     parameters: parameters as [String : AnyObject]?,
                                     headers: headers, converter: { (json) -> AnyObject? in
                                        if data.command == "getPromotionList" {
                                            return apiConverter.fromJson(json: json) as PromotionOutputDomainModel
                                        } else if data.command == "getMyPromotionList" {
                                            return apiConverter.fromJson(json: json) as MyPromotionOutputDomainModel
                                        }
                                        return nil
            },
                                     
                                     callback: callback)
            
        } catch {
            // Change it with the real error
            callback(.Failure(.UnknownError))
        }
    }
    
    func sendMessage(data: SendMessageInputModel,  callback: @escaping (ECallbackResultType) -> Void) {
        do {
            let api: ApiServiceProtocol = ApiService()
            let url: String = try api.constructApiEndpoint(base: "http://182.72.44.11/expert_connect", params: "notification_activity.php")
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
