//
//  NotificationsAPIDataManager.swift
//  ExpertConnect
//
//  Created by Redbytes on 21/11/16.
//  Copyright © 2016 user. All rights reserved.

import Foundation
import SwiftyJSON

final class NotificationsAPIDataManager: NotificationsProtocols, NotificationCountProtocols {
    init() {}
    
    func getNotificationsDetails(model: NotificationsDomainModel, callback: @escaping (ECallbackResultType) -> Void) {
        do {
            let api: ApiServiceProtocol = ApiService() 
            let url: String = try api.constructApiEndpoint(base: "http://182.72.44.11/expert_connect", params: "notification_history.php")
            let headers = try api.constructHeader(withCsrfToken: true, cookieDictionary: nil)
            let parameters = ["user_id" : model.userId as AnyObject] as [String: AnyObject]
            
            let apiConverter = NotificationsApiModelConverter()
            
            api.create(url,
                       parameters: parameters as [String : AnyObject]?,
                       headers: headers, converter: { (json) -> AnyObject in
                        return apiConverter.fromJson(json: json) as NotificationsOutputDomainModel},
                       callback: callback)
        } catch {
            // Change it with the real error
            callback(.Failure(.UnknownError))
        }
    }
    
    func getNotificationCount(model: NotificationsDomainModel, callback: @escaping (ECallbackResultType) -> Void) {
        do {
            let api: ApiServiceProtocol = ApiService()
            let url: String = try api.constructApiEndpoint(base: "http://182.72.44.11/expert_connect", params: "count_notification.php")
            let headers = try api.constructHeader(withCsrfToken: true, cookieDictionary: nil)
            let parameters = ["user_id" : model.userId as AnyObject] as [String: AnyObject]
            
            let apiConverter = NotificationsApiModelConverter()
            
            api.create(url,
                       parameters: parameters as [String : AnyObject]?,
                       headers: headers, converter: { (json) -> AnyObject in
                        return apiConverter.fromNotificationCountJson(json: json) as NotificationCountOutputDomainModel},
                       callback: callback)
        } catch {
            // Change it with the real error
            callback(.Failure(.UnknownError))
        }
    }

}
