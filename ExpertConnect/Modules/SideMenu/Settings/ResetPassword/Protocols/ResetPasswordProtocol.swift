//
//  ResetPasswordProtocol.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

protocol ResetPasswordProtocol {
    func resetPassword(data: ResetPasswordInputDomainModel,  callback: @escaping (ECallbackResultType) -> Void)
}
