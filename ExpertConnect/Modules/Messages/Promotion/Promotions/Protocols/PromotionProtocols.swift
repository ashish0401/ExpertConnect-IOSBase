//
//  PromotionProtocols.swift
//  ExpertConnect
//
//  Created by Nadeem on 23/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
protocol PromotionProtocols {
    func getPromotionList(data:PromotionDomainModel,  callback: @escaping (ECallbackResultType) -> Void)
    func sendMessage(data: SendMessageInputModel,  callback: @escaping (ECallbackResultType) -> Void)
}
