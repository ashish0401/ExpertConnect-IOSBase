//
//  verifyEmailAndMobileNoProtocols.swift
//  ExpertConnect
//
//  Created by Nadeem on 23/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
protocol verifyEmailAndMobileNoProtocols {
    
    func verifyEmailAndMobileNo(data:verifyEmailAndMobileNoInputDomainModel,callback: @escaping (ECallbackResultType) -> Void)
}
