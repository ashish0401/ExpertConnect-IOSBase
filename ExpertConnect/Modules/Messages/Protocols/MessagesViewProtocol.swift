//
//  AddBlogViewProtocol.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

protocol MessagesViewProtocol {
    func getNotificationList(data: MessagesViewInputDomainModel,  callback: @escaping (ECallbackResultType) -> Void)
    func sendEnquiry(data: SendEnquiryInputModel,  callback: @escaping (ECallbackResultType) -> Void)
}
