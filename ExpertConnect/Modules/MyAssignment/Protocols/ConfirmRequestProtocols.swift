//
//  ConfirmRequestProtocols.swift
//  ExpertConnect
//
//  Created by Redbytes on 09/01/17.
//  Copyright © 2017 user. All rights reserved.
//

import Foundation
protocol ConfirmRequestProtocols {
    
    func sendConfirmRejectRequest(data:SendConfirmRejectDomainModel,callback: @escaping (ECallbackResultType) -> Void)
}
