//
//  GetOTPProtocol.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

protocol GetOTPProtocol {
    func getOTP(data:String,  callback: @escaping (ECallbackResultType) -> Void)
}
