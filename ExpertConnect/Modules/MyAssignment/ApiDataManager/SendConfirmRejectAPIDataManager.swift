//
//  SendConfirmRejectAPIDataManager.swift
//  ExpertConnect
//
//  Created by Redbytes on 09/01/17.
//  Copyright © 2017 user. All rights reserved.
//

import Foundation
import SwiftyJSON

final class SendConfirmRejectAPIDataManager: ConfirmRequestProtocols {
    init() {}
    
    func sendConfirmRejectRequest(data:SendConfirmRejectDomainModel,  callback: @escaping (ECallbackResultType) -> Void) {
        do {
            let api: ApiServiceProtocol = ApiService()
            let url: String = try api.constructApiEndpoint(base: "http://182.72.44.11/expert_connect", params: "confirm_reject_notification.php")
            let headers = try api.constructHeader(withCsrfToken: true, cookieDictionary: nil)
            let parameters = ["from_id" : data.fromId, "to_id" : data.toId, "type" : data.type, "expert_id" : data.expertId] as [String : Any]
            
            let apiConverter = SendConfirmRejectApiModelConverter()
            api.createForgotPassword(url,
                                     parameters: parameters as [String : AnyObject]?,
                                     headers: headers, converter: { (json) -> AnyObject in
                                        return apiConverter.fromJson(json: json) as SendConfirmRejectOutputDomainModel},
                                     callback: callback)
            
        } catch {
            // Change it with the real error
            callback(.Failure(.UnknownError))
        }
    }
}
