//
//  SendRequestProtocols.swift
//  ExpertConnect
//
//  Created by Nadeem on 23/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
protocol SendRequestProtocols {
    
    func sendRequest(data:SendRequestDomainModel,callback: @escaping (ECallbackResultType) -> Void)
    func sendAcceptRejectRequest(data:SendRequestDomainModel,callback: @escaping (ECallbackResultType) -> Void)
}
