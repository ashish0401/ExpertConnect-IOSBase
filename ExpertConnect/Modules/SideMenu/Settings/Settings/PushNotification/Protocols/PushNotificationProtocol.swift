//
//  PushNotificationProtocol.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

protocol PushNotificationProtocol {
    func setNotificationOnOff(data: PushNotificationInputDomainModel,  callback: @escaping (ECallbackResultType) -> Void)
}
