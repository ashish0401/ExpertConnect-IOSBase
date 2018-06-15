//
//  ExpertDetailsProtocol.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

protocol ExpertDetailsProtocol {
    func expertDetails(apiEndPoint: String, data:ExpertDetailsInputDomainModel,  callback: @escaping (ECallbackResultType) -> Void)
}
